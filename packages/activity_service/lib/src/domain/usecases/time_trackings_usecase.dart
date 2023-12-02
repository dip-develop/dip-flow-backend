import 'package:built_collection/built_collection.dart';

import '../exceptions/exceptions.dart';
import '../interfaces/interfaces.dart';
import '../models/models.dart';
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
  Future<PaginationModel<TimeTrackingModel>> getTimeTrackings({
    required int userId,
    int? offset,
    int? limit,
    DateTime? start,
    DateTime? end,
    String? search,
  }) =>
      _dataBaseRepository
          .getTimeTracksByUserId(
            id: userId,
            offset: offset,
            limit: limit,
            start: start,
            end: end,
            search: search,
          )
          .then((value) => PaginationModel(
              count: value.count,
              offset: value.offset,
              limit: value.limit,
              items: value.items
                  .map((e) => e.rebuild((p0) => p0
                    ..tracks = ListBuilder(p0.tracks.build().where((p0) {
                      if (start == null && end == null) return true;
                      final condition = start != null && end != null
                          ? ((p0.start == start || p0.start.isAfter(start)) &&
                                  (p0.end == null ||
                                      p0.end == end ||
                                      p0.start.isBefore(end))) &&
                              (p0.end == null ||
                                  p0.end == end ||
                                  p0.end!.isBefore(end))
                          : start != null
                              ? p0.start == start || p0.start.isAfter(start)
                              : p0.end == null ||
                                  p0.end == end ||
                                  p0.end!.isBefore(end!);

                      return condition;
                    }))))
                  .toList()));

  @override
  Future<TimeTrackingModel> addTimeTracking({
    required int userId,
    int? taskId,
    String? title,
    String? description,
  }) =>
      _dataBaseRepository.putTimeTrack(TimeTrackingModel(
        (p0) => p0
          ..userId = userId
          ..taskId = taskId
          ..title = title
          ..description = description
          ..tracks = ListBuilder(List<TrackModel>.empty()),
      ));

  @override
  Future<TimeTrackingModel> updateTimeTracking({
    required int id,
    int? taskId,
    String? title,
    String? description,
    List<TrackModel>? tracks,
  }) =>
      getTimeTracking(id).then((timeTrack) {
        final needDelete = List<Future<void>>.empty(growable: true);
        if (tracks != null) {
          final a = timeTrack.tracks
              .where((p0) => !tracks.any((element) => element.id == p0.id))
              .map((e) => _dataBaseRepository.deleteTrack(e.id!));
          needDelete.addAll(a);
        }
        return Future.wait(needDelete)
            .then((_) => Future.wait(List.generate(tracks?.length ?? 0,
                (index) => _dataBaseRepository.putTrack(tracks![index]))))
            .then((_) => _dataBaseRepository.putTimeTrack(timeTrack.rebuild(
                (p0) => p0
                  ..taskId = taskId ?? p0.taskId
                  ..title = title ?? p0.title
                  ..description = description ?? p0.description
                  ..tracks =
                      tracks != null ? ListBuilder(tracks) : p0.tracks)));
      });

  @override
  Future<void> deleteTimeTracking(int id) =>
      _dataBaseRepository.deleteTimeTrack(id);

  @override
  Future<TimeTrackingModel> startTrack(int id) =>
      stopTrack(id).then((value) => getTimeTracking(id).then((value) {
            final track =
                TrackModel((p0) => p0..start = DateTime.now().toUtc());
            final tracks = List<TrackModel>.from(value.tracks, growable: true);
            tracks.add(track);
            return updateTimeTracking(id: id, tracks: tracks);
          }));

  @override
  Future<TimeTrackingModel> stopTrack(int id) =>
      getTimeTracking(id).then((value) {
        final tracks = List<TrackModel>.from(value.tracks, growable: true);
        TrackModel? stopedTrack;
        for (var i = 0; i < tracks.length; i++) {
          if (tracks[i].end == null) {
            final track =
                tracks[i].rebuild((p0) => p0..end = DateTime.now().toUtc());
            tracks[i] = track;
            stopedTrack = track;
          }
        }
        if (stopedTrack != null) {
          return updateTimeTracking(id: id, tracks: tracks);
        }
        return value;
      });

  @override
  Future<TimeTrackingModel> deleteTrack(
          {required int id, required int trackId}) =>
      getTimeTracking(id).then((value) {
        final tracks = List<TrackModel>.from(value.tracks, growable: true);
        tracks.removeWhere((element) => element.id == trackId);
        return updateTimeTracking(id: id, tracks: tracks);
      });
}
