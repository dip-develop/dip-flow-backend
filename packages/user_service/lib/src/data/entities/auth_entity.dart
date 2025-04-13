// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive.dart';

import '../../domain/models/models.dart';

part 'auth_entity.g.dart';

@HiveType(typeId: 0)
class EmailAuthEntity
    with HiveObjectMixin, EquatableMixin
    implements AuthEntity {
  @HiveField(0)
  @override
  String userId;
  @HiveField(1)
  final String email;
  @HiveField(2)
  final String password;
  @HiveField(3)
  final bool isVerified;
  @HiveField(4)
  @override
  final DateTime dateCreated;

  EmailAuthEntity({
    required this.userId,
    required this.email,
    required this.password,
    required this.isVerified,
    required this.dateCreated,
  });

  EmailAuthModel toModel() => EmailAuthModel((p0) => p0
    ..id = key.toString()
    ..userId = userId
    ..email = email
    ..password = password
    ..dateCreated = dateCreated);

  factory EmailAuthEntity.fromModel(EmailAuthModel model) => EmailAuthEntity(
        userId: model.userId,
        email: model.email,
        password: model.password,
        isVerified: model.isVerified,
        dateCreated: model.dateCreated,
      );

  @override
  List<Object?> get props => [key, userId, password, isVerified, dateCreated];
}

@HiveType(typeId: 1)
class OpenAuthEntity
    with HiveObjectMixin, EquatableMixin
    implements AuthEntity {
  @HiveField(0)
  @override
  String userId;
  @HiveField(1)
  final String identifier;
  @HiveField(2)
  @override
  final DateTime dateCreated;

  OpenAuthEntity({
    required this.userId,
    required this.identifier,
    required this.dateCreated,
  });

  @override
  List<Object?> get props => [key, userId, identifier, dateCreated];
}

abstract class AuthEntity {
  final String userId;
  final DateTime dateCreated;

  const AuthEntity({
    required this.userId,
    required this.dateCreated,
  });
}
