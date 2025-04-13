import 'dart:async';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:hive_ce/hive.dart';
import 'package:logging/logging.dart';
import 'package:synchronized/synchronized.dart';
import 'package:activity_service/src/domain/exceptions/exceptions.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/models.dart';
import '../../domain/repositories/repositories.dart';
import '../entities/entities.dart';

@Singleton(as: DataBaseRepository)
class DataBaseRepositoryImpl implements DataBaseRepository {
  final _log = Logger('DataBaseRepositoryImpl');

  bool _isInneted = false;
  Timer? _timer;
  final _boxOpenedTime = Map<String, DateTime>.identity();
  final _lock = Lock(reentrant: true);

  @override
  @PostConstruct()
  void init() {
    final directory = Platform.environment['DB_DIRECTORY'] ?? 'db';
    final dbUnUsedClosePeriod =
        int.tryParse(Platform.environment['DB_UNUSED_CLOSE_PERIOD'] ?? '') ??
        10;

    _log.config('DB_DIRECTORY is $directory');
    _log.config('DB_UNUSED_CLOSE_PERIOD is $dbUnUsedClosePeriod');

    if (!_isInneted) {
      Hive.init(directory);
    }

    final timeTrackingEntityAdapter = TimeTrackingEntityAdapter();
    final trackEntityAdapter = TrackEntityAdapter();

    if (!Hive.isAdapterRegistered(timeTrackingEntityAdapter.typeId)) {
      Hive.registerAdapter(timeTrackingEntityAdapter);
    }
    if (!Hive.isAdapterRegistered(trackEntityAdapter.typeId)) {
      Hive.registerAdapter(trackEntityAdapter);
    }

    if (_timer?.isActive == true) {
      _timer?.cancel();
    }

    Timer.periodic(
      Duration(seconds: dbUnUsedClosePeriod),
      (_) => _closeUnusedBoxs(),
    );
    _isInneted = true;
  }

  @override
  Future<TimeTrackingModel?> getTimeTracking(String id) =>
      _getBox<TimeTrackingEntity>().then((box) => box.get(id)).then((
        timeTrack,
      ) {
        if (timeTrack == null) return null;
        if (timeTrack.trackIds.isEmpty) {
          return timeTrack.toModel();
        }
        return getTracksByTimeTrackingId(id).then(
          (value) =>
              timeTrack.toModel(value.sortedBy((element) => element.start)),
        );
      });

  @override
  Future<PaginationModel<TimeTrackingModel>> getTimeTrackingsByUserId({
    required String userId,
    int? offset,
    int? limit,
    DateTime? start,
    DateTime? end,
    String? search,
  }) => _getBox<TimeTrackingEntity>()
      .then((box) {
        return box.values.where(
          (element) =>
              element.userId == userId &&
              ((search != null && search.trim().isNotEmpty)
                  ? ((element.title?.contains(search) ?? true) ||
                      (element.description?.contains(search) ?? true))
                  : true),
        );
      })
      .then((timeTrackings) {
        final timeTrackingIds = timeTrackings.map((e) => e.key.toString());
        return _getBox<TrackEntity>()
            .then(
              (value) => value.values.where((element) {
                final hasTimeTrakings = timeTrackingIds.contains(
                  element.timeTrackingId,
                );
                if (start == null && end == null) return hasTimeTrakings;
                final condition =
                    start != null && end != null
                        ? ((element.start == start ||
                                    element.start.isAfter(start)) &&
                                (element.end == null ||
                                    element.end == end ||
                                    element.start.isBefore(end))) &&
                            (element.end == null ||
                                element.end == end ||
                                element.end!.isBefore(end))
                        : start != null
                        ? element.start == start || element.start.isAfter(start)
                        : element.end == null ||
                            element.end == end ||
                            element.end!.isBefore(end!);
                return hasTimeTrakings && condition;
              }),
            )
            .then(
              (tracks) => timeTrackings
                  .map(
                    (e) => e.toModel(
                      tracks
                          .where(
                            (element) =>
                                element.timeTrackingId == e.key.toString(),
                          )
                          .map((e) => e.toModel())
                          .sortedBy((element) => element.start),
                    ),
                  )
                  .where(
                    (element) =>
                        (start != null || end != null)
                            ? element.tracks.isNotEmpty
                            : true,
                  )
                  .sortedBy(
                    (element) =>
                        element.tracks.map((p0) => p0.start).maxOrNull ??
                        DateTime.now().toUtc(),
                  ),
            );
      })
      .then((value) => value.skip(offset ?? 0))
      .then((value) => value.take(limit ?? value.length))
      .then(
        (timeTrackings) => PaginationModel(
          count: timeTrackings.length,
          offset: offset,
          limit: limit,
          items: timeTrackings.toList(),
        ),
      );

  @override
  Future<TimeTrackingModel> putTimeTrack(TimeTrackingModel timeTrack) {
    final id = timeTrack.id ?? Uuid().v1();
    return _getBox<TimeTrackingEntity>()
        .then((box) => box.put(id, TimeTrackingEntity.fromModel(timeTrack)))
        .then((tracks) => timeTrack.rebuild((p0) => p0..id = id));
  }

  @override
  Future<void> deleteTimeTrack(String id) => getTimeTracking(
    id,
  ).then((_) => _getBox<TimeTrackingEntity>().then((box) => box.delete(id)));

  @override
  Future<List<TrackModel>> getTracksByTimeTrackingId(String timeTrackingId) =>
      _getBox<TrackEntity>()
          .then(
            (box) => box.values.where(
              (element) => element.timeTrackingId == timeTrackingId,
            ),
          )
          .then(
            (value) => value
                .map((e) => e.toModel())
                .sortedBy((element) => element.start),
          );

  @override
  Future<TrackModel?> getTrack(String id) => _getBox<TrackEntity>()
      .then((value) => value.get(id))
      .then((value) => value?.toModel());

  @override
  Future<TrackModel> putTrack({
    required String userId,
    required String timeTrackingId,
    required TrackModel track,
  }) {
    final id = track.id ?? Uuid().v1();
    return _getBox<TrackEntity>()
        .then(
          (box) =>
              box.put(id, TrackEntity.fromModel(userId, timeTrackingId, track)),
        )
        .then((_) => track.rebuild((p0) => p0..id = id));
  }

  @override
  Future<void> deleteTrack(String id) => _getBox<TrackEntity>()
      .then((value) => value.get(id))
      .then(
        (track) =>
            track != null
                ? _getBox<TimeTrackingEntity>()
                    .then((box) => box.get(track.timeTrackingId))
                    .then((value) {
                      value?.trackIds.removeWhere((element) => element == id);
                      return value?.save();
                    })
                    .then((_) => track.delete())
                : Future.value(),
      );

  @override
  @disposeMethod
  Future<void> dispose() async {
    _timer?.cancel();
    await Hive.close().then((_) {
      _isInneted = false;
    });
  }

  @override
  bool get isInneted => _isInneted;

  void _closeUnusedBoxs() {
    _lock.synchronized(() {
      final boxes = _boxOpenedTime.entries.where(
        (element) => element.value.isAfter(DateTime.now().toUtc()),
      );
      for (var boxName in boxes.map((e) => e.key)) {
        if (Hive.isBoxOpen(boxName)) {
          final box = switch (boxName) {
            'time_tracking_box' => Hive.box<TimeTrackingEntity>(boxName),
            'track_box' => Hive.box<TrackEntity>(boxName),
            _ => throw DbException.internalError(),
          };
          return box.close().then((_) {
            _log.fine('Close Unused $boxName Box');
            _boxOpenedTime.removeWhere((key, value) => key == boxName);
          });
        }
        _boxOpenedTime.removeWhere((key, value) => key == boxName);
      }
    });
  }

  Future<Box<T>> _getBox<T>() {
    if (!isInneted) throw DbException.notInneted();
    return _lock.synchronized<Box<T>>(() {
      final boxName = switch (T.toString()) {
        'TimeTrackingEntity' => 'time_tracking_box',
        'TrackEntity' => 'track_box',
        _ => throw DbException.internalError(),
      };

      _boxOpenedTime[boxName] = DateTime.now().toUtc();
      if (Hive.isBoxOpen(boxName)) {
        return Future.value(Hive.box<T>(boxName));
      } else {
        return Hive.openBox<T>(boxName).whenComplete(() {
          _log.fine('Open $boxName Box');
        });
      }
    });
  }
}
