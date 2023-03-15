import 'package:objectbox/objectbox.dart';

import '../../domain/models/models.dart';

//part 'session_entity.g.dart';

@Entity()
class SessionEntity {
  @Id()
  int id;
  final int userId;
  @Property(type: PropertyType.date)
  final DateTime dateCreated;
  @Property(type: PropertyType.date)
  final DateTime dateExpired;

  SessionEntity({
    this.id = 0,
    required this.userId,
    required this.dateCreated,
    required this.dateExpired,
  });

  SessionModel toModel() => SessionModel((p0) => p0
    ..id = id
    ..userId = userId
    ..dateCreated = dateCreated
    ..dateExpired = dateExpired);

  factory SessionEntity.fromModel(SessionModel model) => SessionEntity(
        id: model.id ?? 0,
        userId: model.userId,
        dateCreated: model.dateCreated,
        dateExpired: model.dateExpired,
      );
}
