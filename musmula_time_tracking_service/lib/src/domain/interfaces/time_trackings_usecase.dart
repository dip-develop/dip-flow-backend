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
    List<TrackModel>? tracks,
  });
  Future<TimeTrackingModel> getTimeTracking(int id);
  Future<List<TimeTrackingModel>> getTimeTrackings(int userId);
  Future<void> deleteTimeTracking(int id);
}
