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
  Future<List<TimeTrackingModel>> getTimeTracksByUserId(int id) =>
      Future.value(_db
              .box<TimeTrackingEntity>()
              .query(TimeTrackingEntity_.userId.equals(id))
              .build()
              .find())
          .then((value) => value.map((e) => e.toModel()).toList());

  @override
  Future<TimeTrackingModel> putTimeTrack(TimeTrackingModel timeTrack) =>
      Future.value(_db
              .box<TimeTrackingEntity>()
              .put(TimeTrackingEntity.fromModel(timeTrack)))
          .then((value) => timeTrack.rebuild((p0) => p0..id = value));

  @override
  Future<void> deleteTimeTrack(int id) =>
      Future.value(_db.box<TimeTrackingModel>().remove(id)).then((_) {});
}
