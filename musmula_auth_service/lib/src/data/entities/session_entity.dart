import 'package:isar/isar.dart';

import '../../domain/models/models.dart';

part 'session_entity.g.dart';

@collection
class SessionEntity {
  final Id id;
  final int userId;
  final DateTime dateCreated;
  final DateTime dateExpired;

  const SessionEntity(
      {this.id = Isar.autoIncrement,
      required this.userId,
      required this.dateCreated,
      required this.dateExpired});

  SessionModel toModel() => SessionModel((p0) => p0
    ..id = id
    ..userId = userId
    ..dateCreated = dateCreated
    ..dateExpired = dateExpired);

  factory SessionEntity.fromModel(SessionModel model) => SessionEntity(
      id: model.id ?? Isar.autoIncrement,
      userId: model.userId,
      dateCreated: model.dateCreated,
      dateExpired: model.dateExpired);
}
