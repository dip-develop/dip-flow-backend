import 'package:isar/isar.dart';

import '../../domain/models/models.dart';

part 'track_entity.g.dart';

@collection
class TrackEntity {
  @Id()
  int id;
  /* final trackTime = ToOne<TimeTrackingEntity>(); */
  @Index()
  final DateTime start;
  @Index()
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
