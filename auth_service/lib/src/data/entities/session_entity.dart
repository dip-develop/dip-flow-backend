import 'package:objectbox/objectbox.dart';

import '../../domain/models/models.dart';
import 'entities.dart';

@Entity()
class SessionEntity {
  @Id()
  int id;
  final user = ToOne<UserEntity>();
  @Property(type: PropertyType.date)
  final DateTime dateCreated;
  @Property(type: PropertyType.date)
  final DateTime dateExpired;

  SessionEntity({
    this.id = 0,
    required this.dateCreated,
    required this.dateExpired,
  });

  SessionModel toModel() => SessionModel((p0) => p0
    ..id = id
    ..userId = user.targetId
    ..dateCreated = dateCreated
    ..dateExpired = dateExpired);

  factory SessionEntity.fromModel(SessionModel model) => SessionEntity(
        id: model.id ?? 0,
        dateCreated: model.dateCreated,
        dateExpired: model.dateExpired,
      )..user.targetId = model.userId;
}
