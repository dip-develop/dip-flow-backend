import 'package:built_value/built_value.dart';

part 'user_model.g.dart';

abstract class UserModel implements Built<UserModel, UserModelBuilder> {
  int? get id;
  String? get name;
  DateTime get dateCreated;

  UserModel._();
  factory UserModel([void Function(UserModelBuilder) updates]) = _$UserModel;
}
