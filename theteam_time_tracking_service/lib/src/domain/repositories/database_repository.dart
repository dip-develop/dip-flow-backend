import '../models/models.dart';

abstract class DataBaseRepository {
  Future<void> init();

  Future<TimeTrackingModel?> getTimeTrack(int id);
  Future<PaginationModel<TimeTrackingModel>> getTimeTracksByUserId(
      {required int id, required int offset, required int limit});
  Future<TimeTrackingModel> putTimeTrack(TimeTrackingModel timeTrack);
  Future<void> deleteTimeTrack(int id);
  Future<void> deleteTrack(int id);
}
