import '../models/models.dart';

abstract class DataBaseRepository {
  void init();
  bool get isInneted;
  Future<TimeTrackingModel?> getTimeTrack(String id);
  Future<PaginationModel<TimeTrackingModel>> getTimeTracksByUserId({
    required String userId,
    int? offset,
    int? limit,
    DateTime? start,
    DateTime? end,
    String? search,
  });
  Future<TimeTrackingModel> putTimeTrack(TimeTrackingModel timeTrack);
  Future<void> deleteTimeTrack(String id);
  Future<void> putTrack(TrackModel track);
  Future<void> deleteTrack(String id);

  Future<void> dispose();
}
