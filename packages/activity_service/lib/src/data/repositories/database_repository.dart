import 'dart:async';
import 'dart:io';
import 'package:hive_ce/hive.dart';
import 'package:synchronized/synchronized.dart';
import 'package:activity_service/src/domain/exceptions/exceptions.dart';
import 'package:injectable/injectable.dart';

import '../../domain/models/models.dart';
import '../../domain/repositories/repositories.dart';
import '../entities/entities.dart';

@Singleton(as: DataBaseRepository)
class DataBaseRepositoryImpl implements DataBaseRepository {
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
        Duration(seconds: dbUnUsedClosePeriod), (_) => _closeUnusedBoxs());
    _isInneted = true;
  }

  @override
  Future<TimeTrackingModel?> getTimeTrack(String id) =>
      _getBox<TimeTrackingEntity>()
          .then((box) => box.get(id))
          .then((value) => value?.toModel());

  @override
  Future<PaginationModel<TimeTrackingModel>> getTimeTracksByUserId({
    required String userId,
    int? offset,
    int? limit,
    DateTime? start,
    DateTime? end,
    String? search,
  }) =>
      _getBox<TimeTrackingEntity>()
          .then((box) {
            return box.values.where((element) =>
                element.userId == userId &&
                ((search != null && search.isNotEmpty)
                    ? ((element.title?.contains(search) ?? true) ||
                        (element.description?.contains(search) ?? true))
                    : true));
          })
          .then((value) => value.skip(offset ?? 0))
          .then((value) => value.take(limit ?? value.length))
          .then((value) => PaginationModel(
              count: value.length,
              offset: offset,
              limit: limit,
              items: value.map((e) => e.toModel()).toList()));

  @override
  Future<TimeTrackingModel> putTimeTrack(TimeTrackingModel timeTrack) {
    final id = timeTrack.id ?? '';
    return _getBox<TimeTrackingEntity>()
        .then((box) => box.put(id, TimeTrackingEntity.fromModel(timeTrack)))
        .then((_) => timeTrack.rebuild((p0) => p0..id = id));
  }

  @override
  Future<void> deleteTimeTrack(String id) =>
      _getBox<TimeTrackingEntity>().then((box) => box.delete(id));

  @override
  Future<void> putTrack(TrackModel track) {
    final id = track.id ?? '';
    return _getBox<TrackEntity>()
        .then((box) => box.put(id, TrackEntity.fromModel(track)))
        .then((_) => track.rebuild((p0) => p0..id = id));
  }

  @override
  Future<void> deleteTrack(String id) =>
      _getBox<TrackEntity>().then((box) => box.delete(id));

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
      final boxes = _boxOpenedTime.entries
          .where((element) => element.value.isAfter(DateTime.now().toUtc()));
      for (var boxName in boxes.map((e) => e.key)) {
        if (Hive.isBoxOpen(boxName)) {
          final box = switch (boxName) {
            'time_tracking_box' => Hive.box<TimeTrackingEntity>(boxName),
            'track_box' => Hive.box<TrackEntity>(boxName),
            _ => throw DbException.internalError()
          };
          return box.close().then((_) =>
              _boxOpenedTime.removeWhere((key, value) => key == boxName));
        }
        _boxOpenedTime.removeWhere((key, value) => key == boxName);
      }
    });
  }

  Future<Box<T>> _getBox<T>() {
    if (!isInneted) throw DbException.notInneted();
    return _lock.synchronized<Box<T>>(() {
      final boxName = switch (T) {
        TimeTrackingEntity _ => 'time_tracking_box',
        TrackEntity _ => 'track_box',
        _ => throw DbException.internalError()
      };

      _boxOpenedTime[boxName] = DateTime.now().toUtc();
      if (Hive.isBoxOpen(boxName)) {
        return Future.value(Hive.box<T>(boxName));
      } else {
        return Hive.openBox<T>(boxName);
      }
    });
  }
}
