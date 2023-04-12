import 'package:objectbox/objectbox.dart';

import '../../domain/models/models.dart';

@Entity()
class UserEntity {
  @Id()
  int id;
  final String? name;
  @Property(type: PropertyType.date)
  final DateTime dateCreated;

  UserEntity({
    this.id = 0,
    this.name,
    required this.dateCreated,
  });

  UserModel toModel() => UserModel((p0) => p0
    ..id = id
    ..name = name
    ..dateCreated = dateCreated);

  factory UserEntity.fromModel(UserModel model) => UserEntity(
        id: model.id ?? 0,
        name: model.name,
        dateCreated: model.dateCreated,
      );
}
