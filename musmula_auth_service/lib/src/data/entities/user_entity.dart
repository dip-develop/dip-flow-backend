import 'package:isar/isar.dart';

import '../../domain/models/models.dart';

part 'user_entity.g.dart';

@collection
class UserEntity {
  final Id id;
  final String? name;
  final DateTime dateCreated;

  const UserEntity(
      {this.id = Isar.autoIncrement, this.name, required this.dateCreated});

  UserModel toModel() => UserModel((p0) => p0
    ..id = id
    ..name = name
    ..dateCreated = dateCreated);

  factory UserEntity.fromModel(UserModel model) => UserEntity(
        id: model.id ?? Isar.autoIncrement,
        name: model.name,
        dateCreated: model.dateCreated,
      );
}
