import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

part 'profile_model.g.dart';

abstract class ProfileModel implements Built<ProfileModel, ProfileModelBuilder> {
  int? get id;
  String? get name;
  double? get price;
  BuiltList<int> get workDays;
  DateTime get dateCreated;

  ProfileModel._();
  factory ProfileModel([void Function(ProfileModelBuilder) updates]) = _$ProfileModel;
}
