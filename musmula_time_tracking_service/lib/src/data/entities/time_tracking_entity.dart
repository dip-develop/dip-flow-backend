import 'package:built_collection/built_collection.dart';
import 'package:objectbox/objectbox.dart';

import '../../domain/models/models.dart';

@Entity()
class TimeTrackingEntity {
  @Id()
  int id;
  final int userId;
  final String? task;
  final String? title;
  final String? description;
  //final List<TrackEntity> tracks;
  @Backlink('trackTime')
  final tracks = ToMany<TrackEntity>();

  TimeTrackingEntity({
    this.id = 0,
    required this.userId,
    this.task,
    this.title,
    this.description,
    //required this.tracks,
  });

  TimeTrackingModel toModel() => TimeTrackingModel((p0) => p0
    ..id = id
    ..userId = userId
    ..task = task
    ..title = title
    ..description = description
    ..tracks = ListBuilder(tracks.map((element) => element.toModel())));

  factory TimeTrackingEntity.fromModel(TimeTrackingModel model) {
    final timeTrack = TimeTrackingEntity(
      id: model.id ?? 0,
      userId: model.userId,
      task: model.task,
      title: model.title,
      description: model.description,
      //tracks: model.tracks.map((p0) => TrackEntity.fromModel(p0)).toList(),
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
  @Property(type: PropertyType.date)
  final DateTime start;
  @Property(type: PropertyType.date)
  final DateTime? end;

  TrackEntity({this.id = 0, required this.start, this.end});

  TrackModel toModel() => TrackModel((p0) => p0
    ..start = start
    ..end = end);

  factory TrackEntity.fromModel(TrackModel model) => TrackEntity(
        start: model.start,
        end: model.end,
      );
}
