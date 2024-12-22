import 'package:built_value/built_value.dart';

part 'auth_model.g.dart';

abstract class EmailAuthModel
    implements AuthModel, Built<EmailAuthModel, EmailAuthModelBuilder> {
  @override
  String? get id;
  @override
  String get userId;
  String get email;
  String get password;
  bool get isVerified;
  @override
  DateTime get dateCreated;

  EmailAuthModel._();
  factory EmailAuthModel([void Function(EmailAuthModelBuilder) updates]) =
      _$EmailAuthModel;

  @BuiltValueHook(initializeBuilder: true)
  static void _setDefaults(EmailAuthModelBuilder b) => b..isVerified = false;
}

abstract class AuthModel {
  String? get id;
  String get userId;
  DateTime get dateCreated;
}
