import 'dart:io';

import 'package:injectable/injectable.dart';

import '../../../objectbox.g.dart';
import '../../domain/models/models.dart';
import '../../domain/repositories/repositories.dart';
import '../entities/entities.dart';

@Singleton(as: DataBaseRepository)
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
  Future<PaginationModel<TimeTrackingModel>> getTimeTracksByUserId(
      {required int id, required int offset, required int limit}) {
    final query = _db
        .box<TimeTrackingEntity>()
        .query(TimeTrackingEntity_.userId.equals(id))
        .build();

    final count = query.count();

    final timeTraks = (query
          ..limit = limit
          ..offset = offset)
        .find();

    return Future.value(timeTraks).then((value) => PaginationModel(
        count: count,
        offset: offset,
        limit: limit,
        items: value.map((e) => e.toModel()).toList()));
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
  Future<void> deleteTrack(int id) =>
      Future.value(_db.box<TrackEntity>().remove(id)).then((_) {});
}
