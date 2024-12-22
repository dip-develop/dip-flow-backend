import 'package:built_collection/built_collection.dart';
import 'package:isar/isar.dart';

import '../../domain/models/models.dart';

part 'profile_entity.g.dart';

@collection
class ProfileEntity {
  @Id()
  int id;
  final String? name;
  final double? price;
  final List<int> workDays;
  final DateTime dateCreated;

  ProfileEntity({
    this.id = 0,
    this.name,
    this.price,
    this.workDays = const <int>[],
    required this.dateCreated,
  });

  ProfileModel toModel() => ProfileModel((p0) => p0
    ..id = id
    ..name = name
    ..price = price
    ..workDays = ListBuilder(workDays)
    ..dateCreated = dateCreated);

  factory ProfileEntity.fromModel(ProfileModel model) => ProfileEntity(
        id: model.id ?? 0,
        name: model.name,
        price: model.price,
        workDays: model.workDays.toList(),
        dateCreated: model.dateCreated,
      );
}
