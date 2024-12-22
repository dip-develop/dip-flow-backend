import 'package:isar/isar.dart';

import '../../domain/models/models.dart';

part 'session_entity.g.dart';

@collection
class SessionEntity {
  @Id()
  int id;
  //final user = ToOne<ProfileEntity>();
  final String deviceId;
  final DateTime dateCreated;
  final DateTime dateExpired;

  SessionEntity({
    this.id = 0,
    required this.deviceId,
    required this.dateCreated,
    required this.dateExpired,
  });

  SessionModel toModel() => SessionModel((p0) => p0
    ..id = id
    //..userId = user.targetId
    ..deviceId = deviceId
    ..dateCreated = dateCreated
    ..dateExpired = dateExpired);

  factory SessionEntity.fromModel(SessionModel model) => SessionEntity(
        id: model.id ?? 0,
        deviceId: model.deviceId,
        dateCreated: model.dateCreated,
        dateExpired: model.dateExpired,
      ) /* ..user.targetId = model.userId */;
}
