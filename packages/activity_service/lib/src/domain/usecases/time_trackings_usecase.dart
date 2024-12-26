import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';

import '../exceptions/exceptions.dart';
import '../interfaces/interfaces.dart';
import '../models/models.dart';
import '../repositories/repositories.dart';

@Singleton(as: TimeTrackingsUseCase)
class TimeTrackingsUseCaseImpl implements TimeTrackingsUseCase {
  final DataBaseRepository _dataBaseRepository;

  TimeTrackingsUseCaseImpl(this._dataBaseRepository);

  @override
  Future<TimeTrackingModel> getTimeTracking(String id) =>
      _dataBaseRepository.getTimeTracking(id).then((value) {
        if (value == null) {
          throw DbException.notFound();
        }
        return value;
      });

  @override
  Future<PaginationModel<TimeTrackingModel>> getTimeTrackings(
          {required String userId,
          int? offset,
          int? limit,
          DateTime? start,
          DateTime? end,
          String? search}) =>
      _dataBaseRepository.getTimeTrackingsByUserId(
          userId: userId,
          offset: offset,
          limit: limit,
          start: start,
          end: end,
          search: search);

  @override
  Future<TimeTrackingModel> addTimeTracking(
          {required String userId,
          String? taskId,
          String? title,
          String? description}) =>
      _dataBaseRepository.putTimeTrack(TimeTrackingModel((p0) => p0
        ..userId = userId
        ..taskId = taskId
        ..title = title
        ..description = description));

  @override
  Future<TimeTrackingModel> updateTimeTracking(
          {required String id,
          String? taskId,
          String? title,
          String? description,
          List<TrackModel>? tracks}) =>
      getTimeTracking(id).then((timeTrack) {
        final toDelete = tracks != null
            ? timeTrack.tracks
                .whereNot((element) => tracks.any((p0) => element.id == p0.id))
                .map((e) => _dataBaseRepository.deleteTrack(e.id!))
            : List<Future<void>>.empty();

        final toUpdate = List.generate(
            tracks?.length ?? 0,
            (index) => _dataBaseRepository.putTrack(
                userId: timeTrack.userId,
                timeTrackingId: timeTrack.id!,
                track: tracks![index]));

        return Future.wait([...toDelete, ...toUpdate]).then(
            (_) => _dataBaseRepository.putTimeTrack(timeTrack.rebuild((p0) => p0
              ..taskId = taskId ?? p0.taskId
              ..title = title ?? p0.title
              ..description = description ?? p0.description
              ..tracks = tracks != null ? ListBuilder(tracks) : p0.tracks)));
      });

  @override
  Future<void> deleteTimeTracking(String id) => _dataBaseRepository
      .getTracksByTimeTrackingId(id)
      .then((value) => Future.wait([
            ...List.generate(value.length,
                (index) => _dataBaseRepository.deleteTrack(value[index].id!)),
            _dataBaseRepository.deleteTimeTrack(id),
          ]));

  @override
  Future<TimeTrackingModel> startTimeTracking(String id) =>
      _stopTimeTracking(id).then((value) => getTimeTracking(id).then((value) {
            final track =
                TrackModel((p0) => p0..start = DateTime.now().toUtc());
            final tracks = List<TrackModel>.from(value.tracks, growable: true);
            tracks.add(track);
            return updateTimeTracking(id: id, tracks: tracks);
          }));

  @override
  Future<TimeTrackingModel> stopTimeTracking(String id) =>
      _stopTimeTracking(id).then((_) => getTimeTracking(id));

  Future<void> _stopTimeTracking(String id) => getTimeTracking(id)
      .then((timeTracking) =>
          _dataBaseRepository.getTracksByTimeTrackingId(id).then((value) {
            final notStoped =
                value.where((element) => element.end == null).toList();
            return Future.wait(List.generate(
                notStoped.length,
                (index) => _dataBaseRepository.putTrack(
                    userId: timeTracking.userId,
                    timeTrackingId: id,
                    track: notStoped[index]
                        .rebuild((p0) => p0..end = DateTime.now().toUtc()))));
          }))
      .then((_) => Future.value());

  @override
  Future<void> deleteTrack(String id) => _dataBaseRepository.deleteTrack(id);
}
