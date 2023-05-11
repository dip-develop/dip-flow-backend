import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';

import '../domain/exceptions/exceptions.dart';
import '../domain/interfaces/interfaces.dart';
import '../generated/google/protobuf/empty.pb.dart';
import '../generated/google/protobuf/timestamp.pb.dart';
import '../generated/user_models.pb.dart';
import '../generated/user_service.pbgrpc.dart';

@singleton
class UserService extends UserServiceBase {
  final UserUseCase _userUseCase;
  final AuthUseCase _authUseCase;

  UserService(this._authUseCase, this._userUseCase);

  @override
  Future<UserReply> getUser(ServiceCall call, Empty request) {
    final completer = Completer<UserReply>();
    final token = _getToken(call);
    if (token == null || !_authUseCase.checkAccessToken(token)) {
      final error = AuthException.wrongAuthData();
      call.sendTrailers(
          status: StatusCode.invalidArgument, message: error.message);
      completer.completeError(error);
    } else {
      _userUseCase.getUser(token).then((user) {
        completer.complete(UserReply(
            id: user.id,
            name: user.name,
            dateCreated: Timestamp.fromDateTime(user.dateCreated)));
      }).catchError((onError) {
        if (onError is AuthException) {
          call.sendTrailers(
              status: StatusCode.unauthenticated, message: onError.message);
        } else {
          call.sendTrailers(status: StatusCode.unknown);
        }
        completer.completeError(onError);
      });
    }

    return completer.future;
  }

  @override
  Future<Empty> updateUser(ServiceCall call, UserRequest request) {
    final completer = Completer<Empty>();
    final token = _getToken(call);
    if (token == null || !_authUseCase.checkAccessToken(token)) {
      final error = AuthException.wrongAuthData();
      call.sendTrailers(
          status: StatusCode.invalidArgument, message: error.message);
      completer.completeError(error);
    } else {
      _userUseCase
          .getUser(token)
          .then((value) => _userUseCase.updateUser(value.rebuild(
                (p0) => p0
                  ..name = request.hasName() ? request.name : value.name
                  ..price = request.hasPrice() ? request.price : value.price
                  ..workDays = request.workDays.isNotEmpty
                      ? ListBuilder(request.workDays)
                      : value.workDays.toBuilder(),
              )))
          .then((user) {
        completer.complete(Empty());
      }).catchError((onError) {
        if (onError is AuthException) {
          call.sendTrailers(
              status: StatusCode.unauthenticated, message: onError.message);
        } else {
          call.sendTrailers(status: StatusCode.unknown);
        }
        completer.completeError(onError);
      });
    }

    return completer.future;
  }

  String? _getToken(ServiceCall call) => (call.clientMetadata
              ?.map((key, value) => MapEntry(key.toLowerCase(), value))
              .containsKey('authorization') ??
          false)
      ? call.clientMetadata
          ?.map((key, value) => MapEntry(key.toLowerCase(), value))[
              'authorization']
          ?.replaceAll('Bearer', '')
          .replaceAll('bearer', '')
          .trim()
      : null;

  @override
  Future<Empty> deleteUser(ServiceCall call, Empty request) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }
}
