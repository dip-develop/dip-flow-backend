import 'dart:io';

import 'package:activity_service/src/domain/exceptions/exceptions.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

import '../../domain/models/models.dart';
import '../../domain/repositories/repositories.dart';
import '../entities/entities.dart';

@Singleton(as: DataBaseRepository)
class DataBaseRepositoryImpl implements DataBaseRepository {
  bool _isInneted = false;
  late final Isar _db;

  @override
  @PostConstruct()
  Future<void> init() {
    final directory = Platform.environment['DB_DIRECTORY'] ?? 'db';
    return Isar.openAsync(
      directory: directory,
      schemas: [
        TimeTrackingEntitySchema,
        TrackEntitySchema,
      ],
    ).then((value) {
      _db = value;
      _isInneted = true;
    });
  }

  @override
  Future<TimeTrackingModel?> getTimeTrack(int id) =>
      _getDb.timeTrackingEntitys.getAsync(id).then((value) => value?.toModel());

  @override
  Future<PaginationModel<TimeTrackingModel>> getTimeTracksByUserId({
    required int id,
    int? offset,
    int? limit,
    DateTime? start,
    DateTime? end,
    String? search,
  }) {
    final db = _getDb;

    var qb = db.timeTrackingEntitys.where()..userIdEqualTo(id);

    if (search != null && search.isNotEmpty) {
      qb = qb
        ..titleContains(search, caseSensitive: false)
            .or()
            .descriptionContains(search, caseSensitive: false);
    }

    /* if (start != null || end != null) {
      final condition = start != null && end != null
          ? TrackEntity_.start
              .between(start.millisecondsSinceEpoch, end.millisecondsSinceEpoch)
              .and(TrackEntity_.end.isNull().or(TrackEntity_.end.notNull().and(
                  TrackEntity_.end.lessOrEqual(end.millisecondsSinceEpoch))))
          : start != null
              ? TrackEntity_.start.greaterOrEqual(start.millisecondsSinceEpoch)
              : TrackEntity_.end.isNull().or(
                  TrackEntity_.end.lessOrEqual(end!.millisecondsSinceEpoch));

      queryBuilder.linkMany(TimeTrackingEntity_.tracks, condition);
    } */

    final count = qb.count();

    return qb.findAllAsync(offset: offset, limit: limit).then((value) =>
        PaginationModel(
            count: count,
            offset: offset,
            limit: limit,
            items: value.map((e) => e.toModel()).toList()));
  }

  @override
  Future<TimeTrackingModel> putTimeTrack(TimeTrackingModel timeTrack) =>
      _getDb.writeAsync((isar) {
        final id = timeTrack.id ?? isar.timeTrackingEntitys.autoIncrement();
        final data = timeTrack.rebuild((p0) => p0..id = id);
        isar.timeTrackingEntitys.put(TimeTrackingEntity.fromModel(data));
        return data;
      });

  @override
  Future<void> deleteTimeTrack(int id) =>
      Future.value(/* _db.box<TimeTrackingEntity>().remove(id)).then((_) {} */);

  @override
  Future<void> putTrack(TrackModel track) => Future.value(
      /* _db.box<TrackEntity>().put(TrackEntity.fromModel(track)))
          .then((value) => track.rebuild((p0) => p0..id = value) */
      );

  @override
  Future<void> deleteTrack(int id) =>
      Future.value(/* _db.box<TrackEntity>().remove(id)).then((_) {} */);

  @override
  @disposeMethod
  void dispose() {
    _getDb.close();
  }

  @override
  bool get isInneted => _isInneted;

  Isar get _getDb {
    if (!isInneted) throw DbException.notInneted();
    return _db;
  }
}
