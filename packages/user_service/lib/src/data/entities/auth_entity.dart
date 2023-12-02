import 'package:isar/isar.dart';

import '../../domain/models/models.dart';

part 'auth_entity.g.dart';

@collection
class EmailAuthEntity implements AuthEntity {
  @Id()
  @override
  int id;
  //final user = ToOne<ProfileEntity>();
  @Index()
  final String email;
  final String password;
  final bool isVerified;
  @override
  final DateTime dateCreated;

  EmailAuthEntity({
    this.id = 0,
    required this.email,
    required this.password,
    required this.isVerified,
    required this.dateCreated,
  });

  EmailAuthModel toModel() => EmailAuthModel((p0) => p0
    ..id = id
    //..userId = user.targetId
    ..email = email
    ..password = password
    ..dateCreated = dateCreated);

  factory EmailAuthEntity.fromModel(EmailAuthModel model) => EmailAuthEntity(
        id: model.id ?? 0,
        email: model.email,
        password: model.password,
        isVerified: model.isVerified,
        dateCreated: model.dateCreated,
      ) /* ..user.targetId = model.userId */;
}

@collection
class OpenAuthEntity implements AuthEntity {
  @Id()
  @override
  int id;
  //final user = ToOne<ProfileEntity>();
  @Index()
  final String identifier;
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
