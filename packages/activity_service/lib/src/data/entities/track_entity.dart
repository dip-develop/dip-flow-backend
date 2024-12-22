// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive.dart';

import '../../domain/models/models.dart';

part 'track_entity.g.dart';

@HiveType(typeId: 1)
class TrackEntity with HiveObjectMixin, EquatableMixin {
  @HiveField(0)
  final DateTime start;
  @HiveField(1)
  final DateTime? end;

  TrackEntity({required this.start, this.end});

  TrackModel toModel() => TrackModel((p0) => p0
    ..id = key
    ..start = start
    ..end = end);

  factory TrackEntity.fromModel(TrackModel model) =>
      TrackEntity(start: model.start, end: model.end);

  @override
  List<Object?> get props => [key, start, end];
}
