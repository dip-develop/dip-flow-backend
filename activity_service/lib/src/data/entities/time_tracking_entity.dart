import 'package:built_collection/built_collection.dart';
import 'package:objectbox/objectbox.dart';

import '../../domain/models/models.dart';

@Entity()
class TimeTrackingEntity {
  @Id()
  int id;
  final int userId;
  @Index(type: IndexType.value)
  final int? taskId;
  @Index(type: IndexType.value)
  final String? title;
  @Index(type: IndexType.value)
  final String? description;
  final tracks = ToMany<TrackEntity>();

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
    ..description = description
    ..tracks = ListBuilder(tracks.map((element) => element.toModel())));

  factory TimeTrackingEntity.fromModel(TimeTrackingModel model) {
    final timeTrack = TimeTrackingEntity(
      id: model.id ?? 0,
      userId: model.userId,
      taskId: model.taskId,
      title: model.title,
      description: model.description,
    );
    timeTrack.tracks
        .addAll(model.tracks.map((p0) => TrackEntity.fromModel(p0)));
    return timeTrack;
  }
}

@Entity()
class TrackEntity {
  @Id()
  int id;
  final trackTime = ToOne<TimeTrackingEntity>();
  @Index()
  @Property(type: PropertyType.date)
  final DateTime start;
  @Index()
  @Property(type: PropertyType.date)
  final DateTime? end;

  TrackEntity({this.id = 0, required this.start, this.end});

  TrackModel toModel() => TrackModel((p0) => p0
    ..id = id
    ..start = start
    ..end = end);

  factory TrackEntity.fromModel(TrackModel model) => TrackEntity(
        id: model.id ?? 0,
        start: model.start,
        end: model.end,
      );
}
