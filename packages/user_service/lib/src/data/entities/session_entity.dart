// ignore_for_file: must_be_immutable

import 'package:hive_ce/hive.dart';
import 'package:equatable/equatable.dart';

import '../../domain/models/models.dart';

part 'session_entity.g.dart';

@HiveType(typeId: 3)
class SessionEntity with HiveObjectMixin, EquatableMixin {
  @HiveField(0)
  final String userId;
  @HiveField(1)
  final String deviceId;
  @HiveField(2)
  final DateTime dateCreated;
  @HiveField(3)
  final DateTime dateExpired;

  SessionEntity({
    required this.userId,
    required this.deviceId,
    required this.dateCreated,
    required this.dateExpired,
  });

  SessionModel toModel() => SessionModel((p0) => p0
    ..id = key.toString()
    ..userId = userId
    ..deviceId = deviceId
    ..dateCreated = dateCreated
    ..dateExpired = dateExpired);

  factory SessionEntity.fromModel(SessionModel model) => SessionEntity(
        userId: model.userId,
        deviceId: model.deviceId,
        dateCreated: model.dateCreated,
        dateExpired: model.dateExpired,
      );

  @override
  List<Object?> get props => [key, deviceId, dateCreated, dateExpired];
}
