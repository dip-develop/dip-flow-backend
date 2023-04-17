import '../models/models.dart';

abstract class DataBaseRepository {
  Future<void> init();

  Future<TimeTrackingModel?> getTimeTrack(int id);
  Future<PaginationModel<TimeTrackingModel>> getTimeTracksByUserId({
    required int id,
    int? offset,
    int? limit,
    DateTime? start,
    DateTime? end,
    String? search,
  });
  Future<TimeTrackingModel> putTimeTrack(TimeTrackingModel timeTrack);
  Future<void> deleteTimeTrack(int id);
  Future<void> deleteTrack(int id);
}
