// ignore_for_file: must_be_immutable

import 'package:built_collection/built_collection.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive.dart';

import '../../domain/models/models.dart';

part 'profile_entity.g.dart';

@HiveType(typeId: 2)
class ProfileEntity with HiveObjectMixin, EquatableMixin {
  @HiveField(0)
  final String? name;
  @HiveField(1)
  final double? price;
  @HiveField(2)
  final List<int> workDays;
  @HiveField(3)
  final DateTime dateCreated;

  ProfileEntity({
    this.name,
    this.price,
    this.workDays = const <int>[],
    required this.dateCreated,
  });

  ProfileModel toModel() => ProfileModel((p0) => p0
    ..id = key.toString()
    ..name = name
    ..price = price
    ..workDays = ListBuilder(workDays)
    ..dateCreated = dateCreated);

  factory ProfileEntity.fromModel(ProfileModel model) => ProfileEntity(
        name: model.name,
        price: model.price,
        workDays: model.workDays.toList(),
        dateCreated: model.dateCreated,
      );

  @override
  List<Object?> get props => [];
}
