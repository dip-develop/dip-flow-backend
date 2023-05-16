import 'package:built_collection/built_collection.dart';
import 'package:objectbox/objectbox.dart';

import '../../domain/models/models.dart';

@Entity(uid: 2507696998683691206)
class ProfileEntity {
  @Id()
  int id;
  final String? name;
  @Property(type: PropertyType.float)
  final double? price;
  @Property(type: PropertyType.byteVector)
  final List<int> workDays;
  @Property(type: PropertyType.date)
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
