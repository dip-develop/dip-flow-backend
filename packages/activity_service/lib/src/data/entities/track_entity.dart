// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive.dart';

import '../../domain/models/models.dart';

part 'track_entity.g.dart';

@HiveType(typeId: 1)
class TrackEntity with HiveObjectMixin, EquatableMixin {
  @HiveField(0)
  final String userId;
  @HiveField(1)
  final String timeTrackingId;
  @HiveField(2)
  final DateTime start;
  @HiveField(3)
  final DateTime? end;

  TrackEntity(
      {required this.userId,
      required this.timeTrackingId,
      required this.start,
      this.end});

  TrackModel toModel() => TrackModel((p0) => p0
    ..id = key.toString()
    ..start = start
    ..end = end);

  factory TrackEntity.fromModel(
          String userId, String timeTrackingId, TrackModel model) =>
      TrackEntity(
          userId: userId,
          timeTrackingId: timeTrackingId,
          start: model.start,
          end: model.end);

  @override
  List<Object?> get props => [key, start, end];
}
