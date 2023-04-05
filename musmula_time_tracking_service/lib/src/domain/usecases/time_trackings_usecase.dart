import 'package:built_collection/built_collection.dart';

import '../exceptions/exceptions.dart';
import '../interfaces/interfaces.dart';
import '../models/time_tracking_model.dart';
import '../repositories/repositories.dart';

class TimeTrackingsUseCaseImpl implements TimeTrackingsUseCase {
  final DataBaseRepository _dataBaseRepository;

  TimeTrackingsUseCaseImpl._(this._dataBaseRepository);

  static Future<TimeTrackingsUseCaseImpl> getInstance(
      DataBaseRepository dataBaseRepository) {
    return dataBaseRepository
        .init()
        .then((_) => TimeTrackingsUseCaseImpl._(dataBaseRepository));
  }

  @override
  Future<TimeTrackingModel> getTimeTracking(int id) =>
      _dataBaseRepository.getTimeTrack(id).then((value) {
        if (value == null) {
          throw DbException.notFound();
        }
        return value;
      });

  @override
  Future<List<TimeTrackingModel>> getTimeTrackings(int userId) =>
      _dataBaseRepository.getTimeTracksByUserId(userId);

  @override
  Future<TimeTrackingModel> addTimeTracking({
    required int userId,
    String? task,
    String? title,
    String? description,
  }) =>
      _dataBaseRepository.putTimeTrack(TimeTrackingModel(
        (p0) => p0
          ..userId = userId
          ..task = task
          ..title = title
          ..description = description
          ..tracks = ListBuilder(List<TrackModel>.empty()),
      ));

  @override
  Future<TimeTrackingModel> updateTimeTracking({
    required int id,
    String? task,
    String? title,
    String? description,
    List<TrackModel>? tracks,
  }) =>
      getTimeTracking(id).then(
          (value) => _dataBaseRepository.putTimeTrack(value.rebuild((p0) => p0
            ..task = task ?? p0.task
            ..title = title ?? p0.title
            ..description = description ?? p0.description
            ..tracks = tracks != null ? ListBuilder(tracks) : p0.tracks)));

  @override
  Future<void> deleteTimeTracking(int id) =>
      _dataBaseRepository.deleteTimeTrack(id);
}
