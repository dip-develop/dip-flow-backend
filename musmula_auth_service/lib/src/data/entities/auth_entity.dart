import 'package:isar/isar.dart';

import '../../domain/models/models.dart';

part 'auth_entity.g.dart';

@collection
class EmailAuthEntity implements AuthEntity {
  @override
  final Id id;
  @override
  final int userId;
  final String email;
  final String password;
  @override
  final DateTime dateCreated;

  const EmailAuthEntity(
      {this.id = Isar.autoIncrement,
      required this.userId,
      required this.email,
      required this.password,
      required this.dateCreated});

  EmailAuthModel toModel() => EmailAuthModel((p0) => p0
    ..id = id
    ..userId = userId
    ..email = email
    ..password = password
    ..dateCreated = dateCreated);

  factory EmailAuthEntity.fromModel(EmailAuthModel model) => EmailAuthEntity(
        id: model.id ?? Isar.autoIncrement,
        userId: model.userId,
        email: model.email,
        password: model.password,
        dateCreated: model.dateCreated,
      );
}

@collection
class OpenAuthEntity implements AuthEntity {
  @override
  final Id id;
  @override
  final int userId;
  final String identifier;
  @override
  final DateTime dateCreated;

  const OpenAuthEntity(
      {this.id = Isar.autoIncrement,
      required this.userId,
      required this.identifier,
      required this.dateCreated});
}

abstract class AuthEntity {
  final Id id;
  final int userId;
  final DateTime dateCreated;

  const AuthEntity(
      {this.id = Isar.autoIncrement,
      required this.userId,
      required this.dateCreated});
}
