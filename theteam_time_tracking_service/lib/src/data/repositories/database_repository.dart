import 'dart:io';

import 'package:injectable/injectable.dart' as inj;

import '../../../objectbox.g.dart';
import '../../domain/models/models.dart';
import '../../domain/repositories/repositories.dart';
import '../entities/entities.dart';

@inj.Singleton(as: DataBaseRepository)
class DataBaseRepositoryImpl implements DataBaseRepository {
  late final Store _db;

  @override
  Future<void> init() {
    final directory = Platform.environment['DB_DIRECTORY'];
    _db = openStore(
      directory: directory,
    );
    return Future.value();
  }

  @override
  Future<TimeTrackingModel?> getTimeTrack(int id) =>
      Future.value(_db.box<TimeTrackingEntity>().get(id)?.toModel());

  @override
  Future<PaginationModel<TimeTrackingModel>> getTimeTracksByUserId({
    required int id,
    int? offset,
    int? limit,
    DateTime? start,
    DateTime? end,
    String? search,
  }) {
    Condition<TimeTrackingEntity> qc = TimeTrackingEntity_.userId.equals(id);

    if (search != null) {
      qc = qc
        ..orAny([
          TimeTrackingEntity_.task.contains(search),
          TimeTrackingEntity_.title.contains(search),
          TimeTrackingEntity_.description.contains(search),
        ]);
    }

    QueryBuilder<TimeTrackingEntity> queryBuilder =
        _db.box<TimeTrackingEntity>().query(qc);

    if (start != null) {
      queryBuilder = queryBuilder
        ..linkMany(TimeTrackingEntity_.tracks,
            TrackEntity_.start.greaterOrEqual(start.millisecond));
    }

    if (end != null) {
      queryBuilder = queryBuilder
        ..linkMany(TimeTrackingEntity_.tracks,
            TrackEntity_.start.lessOrEqual(end.millisecond));
    }

    Query<TimeTrackingEntity> query = queryBuilder
        .order(TimeTrackingEntity_.id, flags: Order.descending)
        .build();

    final count = query.count();

    if (offset != null) {
      query = query..offset = offset;
    }

    if (limit != null) {
      query = query..limit = limit;
    }

    return Future.value(query.find())
        .then((value) => PaginationModel(
            count: count,
            offset: offset,
            limit: limit,
            items: value.map((e) => e.toModel()).toList()))
        .whenComplete(() => query.close());
  }

  @override
  Future<TimeTrackingModel> putTimeTrack(TimeTrackingModel timeTrack) =>
      Future.value(_db
              .box<TimeTrackingEntity>()
              .put(TimeTrackingEntity.fromModel(timeTrack)))
          .then((value) => timeTrack.rebuild((p0) => p0..id = value));

  @override
  Future<void> deleteTimeTrack(int id) =>
      Future.value(_db.box<TimeTrackingEntity>().remove(id)).then((_) {});

  @override
  Future<void> putTrack(TrackModel track) =>
      Future.value(_db.box<TrackEntity>().put(TrackEntity.fromModel(track)))
          .then((value) => track.rebuild((p0) => p0..id = value));

  @override
  Future<void> deleteTrack(int id) =>
      Future.value(_db.box<TrackEntity>().remove(id)).then((_) {});
}
