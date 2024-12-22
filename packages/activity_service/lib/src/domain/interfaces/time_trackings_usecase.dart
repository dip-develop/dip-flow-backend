import '../models/models.dart';

abstract class TimeTrackingsUseCase {
  Future<TimeTrackingModel> addTimeTracking({
    required String userId,
    String? taskId,
    String? title,
    String? description,
  });
  Future<TimeTrackingModel> updateTimeTracking({
    required String id,
    String? taskId,
    String? title,
    String? description,
  });
  Future<TimeTrackingModel> getTimeTracking(String id);
  Future<PaginationModel<TimeTrackingModel>> getTimeTrackings({
    required String userId,
    int? offset,
    int? limit,
    DateTime? start,
    DateTime? end,
    String? search,
  });
  Future<void> deleteTimeTracking(String id);
  Future<TimeTrackingModel> startTrack(String id);
  Future<TimeTrackingModel> stopTrack(String id);
  Future<TimeTrackingModel> deleteTrack(
      {required String id, required String trackId});
}
