// ignore_for_file: must_be_immutable

import 'package:built_collection/built_collection.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive.dart';

import '../../domain/models/models.dart';
import 'entities.dart';

part 'time_tracking_entity.g.dart';

@HiveType(typeId: 0)
class TimeTrackingEntity with HiveObjectMixin, EquatableMixin {
  @HiveField(0)
  final String userId;
  @HiveField(1)
  final String? taskId;
  @HiveField(2)
  final String? title;
  @HiveField(3)
  final String? description;
  @HiveField(4)
  final Set<String> trackIds;

  TimeTrackingEntity({
    required this.userId,
    this.taskId,
    this.title,
    this.description,
    required this.trackIds,
  });

  TimeTrackingModel toModel(
          [List<TrackEntity> tracks = const <TrackEntity>[]]) =>
      TimeTrackingModel((p0) => p0
        ..id = key.toString()
        ..userId = userId
        ..taskId = taskId
        ..title = title
        ..description = description
        ..tracks = ListBuilder(tracks.map((element) => element.toModel())));

  factory TimeTrackingEntity.fromModel(TimeTrackingModel model) {
    final timeTrack = TimeTrackingEntity(
        userId: model.userId,
        taskId: model.taskId,
        title: model.title,
        description: model.description,
        trackIds: model.tracks
            .map((p0) => p0.id)
            .where((element) => element != null)
            .cast<String>()
            .toSet());
    return timeTrack;
  }

  @override
  List<Object?> get props =>
      [key, userId, taskId, title, description, trackIds];
}
