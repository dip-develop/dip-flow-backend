import '../models/models.dart';

abstract class TimeTrackingsUseCase {
  Future<TimeTrackingModel> addTimeTracking({
    required int userId,
    String? task,
    String? title,
    String? description,
  });
  Future<TimeTrackingModel> updateTimeTracking({
    required int id,
    String? task,
    String? title,
    String? description,
  });
  Future<TimeTrackingModel> getTimeTracking(int id);
  Future<PaginationModel<TimeTrackingModel>> getTimeTrackings({
    required int userId,
    int? offset,
    int? limit,
    DateTime? start,
    DateTime? end,
    String? search,
  });
  Future<void> deleteTimeTracking(int id);
  Future<TimeTrackingModel> startTrack(int id);
  Future<TimeTrackingModel> stopTrack(int id);
  Future<TimeTrackingModel> deleteTrack(
      {required int id, required int trackId});
}
