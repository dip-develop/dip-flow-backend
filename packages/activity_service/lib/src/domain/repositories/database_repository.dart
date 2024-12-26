import '../models/models.dart';

abstract class DataBaseRepository {
  void init();
  bool get isInneted;
  Future<TimeTrackingModel?> getTimeTracking(String id);
  Future<PaginationModel<TimeTrackingModel>> getTimeTrackingsByUserId(
      {required String userId,
      int? offset,
      int? limit,
      DateTime? start,
      DateTime? end,
      String? search});
  Future<TimeTrackingModel> putTimeTrack(TimeTrackingModel timeTrack);
  Future<void> deleteTimeTrack(String id);
  Future<TrackModel?> getTrack(String id);
  Future<TrackModel> putTrack(
      {required String userId,
      required String timeTrackingId,
      required TrackModel track});
  Future<List<TrackModel>> getTracksByTimeTrackingId(String timeTrackingId);
  Future<void> deleteTrack(String id);
  Future<void> dispose();
}
