import 'package:isar/isar.dart';

import '../../domain/models/models.dart';

part 'time_tracking_entity.g.dart';

@collection
class TimeTrackingEntity {
  @Id()
  int id;
  final int userId;
  @Index()
  final int? taskId;
  @Index()
  final String? title;
  @Index()
  final String? description;
  //final tracks = ToMany<TrackEntity>();

  TimeTrackingEntity({
    this.id = 0,
    required this.userId,
    this.taskId,
    this.title,
    this.description,
  });

  TimeTrackingModel toModel() => TimeTrackingModel((p0) => p0
    ..id = id
    ..userId = userId
    ..taskId = taskId
    ..title = title
    ..description =
        description /*  ..tracks = ListBuilder(tracks.map((element) => element.toModel())) */);

  factory TimeTrackingEntity.fromModel(TimeTrackingModel model) {
    final timeTrack = TimeTrackingEntity(
      id: model.id!,
      userId: model.userId,
      taskId: model.taskId,
      title: model.title,
      description: model.description,
    );
    /* timeTrack.tracks
        .addAll(model.tracks.map((p0) => TrackEntity.fromModel(p0))); */
    return timeTrack;
  }
}
