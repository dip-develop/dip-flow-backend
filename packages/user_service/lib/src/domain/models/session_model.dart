import 'package:built_value/built_value.dart';

part 'session_model.g.dart';

abstract class SessionModel
    implements Built<SessionModel, SessionModelBuilder> {
  String? get id;
  String get userId;
  String get deviceId;
  DateTime get dateCreated;
  DateTime get dateExpired;

  SessionModel._();
  factory SessionModel([void Function(SessionModelBuilder) updates]) =
      _$SessionModel;
}
