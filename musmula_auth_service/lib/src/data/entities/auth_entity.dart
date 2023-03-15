import 'package:objectbox/objectbox.dart';

import '../../domain/models/models.dart';

//part 'auth_entity.g.dart';

@Entity()
class EmailAuthEntity implements AuthEntity {
  @Id()
  @override
  int id;
  @override
  final int userId;
  final String email;
  final String password;
  @Property(type: PropertyType.date)
  @override
  final DateTime dateCreated;

  EmailAuthEntity({
    this.id = 0,
    required this.userId,
    required this.email,
    required this.password,
    required this.dateCreated,
  });

  EmailAuthModel toModel() => EmailAuthModel((p0) => p0
    ..id = id
    ..userId = userId
    ..email = email
    ..password = password
    ..dateCreated = dateCreated);

  factory EmailAuthEntity.fromModel(EmailAuthModel model) => EmailAuthEntity(
        id: model.id ?? 0,
        userId: model.userId,
        email: model.email,
        password: model.password,
        dateCreated: model.dateCreated,
      );
}

@Entity()
class OpenAuthEntity implements AuthEntity {
  @Id()
  @override
  int id;
  @override
  final int userId;
  final String identifier;
  @Property(type: PropertyType.date)
  @override
  final DateTime dateCreated;

  OpenAuthEntity({
    this.id = 0,
    required this.userId,
    required this.identifier,
    required this.dateCreated,
  });
}

abstract class AuthEntity {
  final int id;
  final int userId;
  final DateTime dateCreated;

  const AuthEntity({
    this.id = 0,
    required this.userId,
    required this.dateCreated,
  });
}
