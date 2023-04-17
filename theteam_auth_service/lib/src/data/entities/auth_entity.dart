import 'package:objectbox/objectbox.dart';

import '../../domain/models/models.dart';
import 'entities.dart';

@Entity()
class EmailAuthEntity implements AuthEntity {
  @Id()
  @override
  int id;
  final user = ToOne<UserEntity>();
  @Index(type: IndexType.value)
  final String email;
  final String password;
  @Property(type: PropertyType.date)
  @override
  final DateTime dateCreated;

  EmailAuthEntity({
    this.id = 0,
    required this.email,
    required this.password,
    required this.dateCreated,
  });

  EmailAuthModel toModel() => EmailAuthModel((p0) => p0
    ..id = id
    ..userId = user.targetId
    ..email = email
    ..password = password
    ..dateCreated = dateCreated);

  factory EmailAuthEntity.fromModel(EmailAuthModel model) => EmailAuthEntity(
        id: model.id ?? 0,
        email: model.email,
        password: model.password,
        dateCreated: model.dateCreated,
      )..user.targetId = model.userId;
}

@Entity()
class OpenAuthEntity implements AuthEntity {
  @Id()
  @override
  int id;
  final user = ToOne<UserEntity>();
  @Index(type: IndexType.value)
  final String identifier;
  @Property(type: PropertyType.date)
  @override
  final DateTime dateCreated;

  OpenAuthEntity({
    this.id = 0,
    required this.identifier,
    required this.dateCreated,
  });
}

abstract class AuthEntity {
  final int id;
  final DateTime dateCreated;

  const AuthEntity({
    this.id = 0,
    required this.dateCreated,
  });
}
