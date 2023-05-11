import 'package:built_collection/built_collection.dart';
import 'package:objectbox/objectbox.dart';

import '../../domain/models/models.dart';

@Entity()
class UserEntity {
  @Id()
  int id;
  final String? name;
  @Property(type: PropertyType.float)
  final double? price;
  @Property(type: PropertyType.byteVector)
  final List<int> workDays;
  @Property(type: PropertyType.date)
  final DateTime dateCreated;

  UserEntity({
    this.id = 0,
    this.name,
    this.price,
    this.workDays = const <int>[],
    required this.dateCreated,
  });

  UserModel toModel() => UserModel((p0) => p0
    ..id = id
    ..name = name
    ..price = price
    ..workDays = ListBuilder(workDays)
    ..dateCreated = dateCreated);

  factory UserEntity.fromModel(UserModel model) => UserEntity(
        id: model.id ?? 0,
        name: model.name,
        price: model.price,
        workDays: model.workDays.toList(),
        dateCreated: model.dateCreated,
      );
}
