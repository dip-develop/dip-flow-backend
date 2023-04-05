import '../models/models.dart';

abstract class DataBaseRepository {
  Future<void> init();

  Future<TimeTrackingModel?> getTimeTrack(int id);
  Future<List<TimeTrackingModel>> getTimeTracksByUserId(int userId);
  Future<TimeTrackingModel> putTimeTrack(TimeTrackingModel timeTrack);
  Future<void> deleteTimeTrack(int id);
}
