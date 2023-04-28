import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

part 'user_model.g.dart';

abstract class UserModel implements Built<UserModel, UserModelBuilder> {
  int? get id;
  String? get name;
  double? get price;
  BuiltList<int> get workDays;
  DateTime get dateCreated;

  UserModel._();
  factory UserModel([void Function(UserModelBuilder) updates]) = _$UserModel;
}
