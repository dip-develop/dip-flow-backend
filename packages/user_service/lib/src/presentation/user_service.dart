import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../domain/exceptions/exceptions.dart';
import '../domain/interfaces/interfaces.dart';
import '../generated/google/protobuf/empty.pb.dart';
import '../generated/google/protobuf/timestamp.pb.dart';
import '../generated/user_models.pb.dart';
import '../generated/user_service.pbgrpc.dart';
import 'utils.dart';

@singleton
class UserService extends UserServiceBase {
  final _log = Logger('UserService');
  final ProfileUseCase _userUseCase;
  final AuthUseCase _authUseCase;

  UserService(this._authUseCase, this._userUseCase);

  @override
  Future<UserReply> getUser(ServiceCall call, Empty request) {
    _log.finer('Call "getUser"');
    final completer = Completer<UserReply>();
    final token = Utils.getToken(call);
    final deviceId = Utils.getDeviceId(call);
    if (token == null ||
        deviceId == null ||
        !_authUseCase.checkAccessToken(token)) {
      final error = AuthException.wrongAuthData();
      call.sendTrailers(
          status: StatusCode.invalidArgument, message: error.message);
      completer.completeError(error);
    } else {
      _userUseCase.getProfile(token, deviceId).then((user) {
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
    _log.finer('Call "updateUser"');
    _log.finest(request.toDebugString());
    final completer = Completer<Empty>();
    final token = Utils.getToken(call);
    final deviceId = Utils.getDeviceId(call);
    if (token == null ||
        deviceId == null ||
        !_authUseCase.checkAccessToken(token)) {
      final error = AuthException.wrongAuthData();
      call.sendTrailers(
          status: StatusCode.invalidArgument, message: error.message);
      completer.completeError(error);
    } else {
      _userUseCase
          .getProfile(token, deviceId)
          .then((value) => _userUseCase.updateProfile(value.rebuild(
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

  @override
  Future<Empty> deleteUser(ServiceCall call, Empty request) {
    _log.finer('Call "deleteUser"');
    // TODO: implement deleteUser
    throw UnimplementedError();
  }
}
