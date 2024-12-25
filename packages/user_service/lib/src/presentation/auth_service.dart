import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../domain/exceptions/auth_exception.dart';
import '../domain/interfaces/interfaces.dart';
import '../generated/auth_models.pb.dart';
import '../generated/auth_service.pbgrpc.dart';
import '../generated/google/protobuf/empty.pb.dart';
import 'utils.dart';

@singleton
class AuthService extends AuthServiceBase {
  final _log = Logger('AuthService');
  final AuthUseCase _authUseCase;

  AuthService(this._authUseCase);

  @override
  Future<AuthReply> signInByEmail(
      ServiceCall call, SignInEmailRequest request) {
    _log.finer('Call "signInByEmail"');
    _log.finest(request.toDebugString());
    final completer = Completer<AuthReply>();
    final deviceId = Utils.getDeviceId(call);
    if (deviceId == null) {
      final error = AuthException.wrongAuthData();
      call.sendTrailers(
          status: StatusCode.invalidArgument, message: error.message);
      completer.completeError(error);
    } else {
      _authUseCase
          .signInByEmail(
        email: request.email,
        password: request.password,
        deviceId: deviceId,
      )
          .then((session) {
        final accessToken = _authUseCase.generateAccessToken(session);
        final refreshToken = _authUseCase.generateRefreshToken(session);

        completer.complete(
            AuthReply(accessToken: accessToken, refreshToken: refreshToken));
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
  Future<AuthReply> signUpByEmail(
      ServiceCall call, SignUpEmailRequest request) {
    _log.finer('Call "signUpByEmail"');
    _log.finest(request.toDebugString());
    final completer = Completer<AuthReply>();
    final deviceId = Utils.getDeviceId(call);
    if (deviceId == null) {
      final error = AuthException.wrongAuthData();
      call.sendTrailers(
          status: StatusCode.invalidArgument, message: error.message);
      completer.completeError(error);
    } else {
      _authUseCase
          .signUpByEmail(
        name: request.name,
        email: request.email,
        password: request.password,
        deviceId: deviceId,
      )
          .then((session) {
        final accessToken = _authUseCase.generateAccessToken(session);
        final refreshToken = _authUseCase.generateRefreshToken(session);
        completer.complete(
            AuthReply(accessToken: accessToken, refreshToken: refreshToken));
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
  Future<AuthReply> refreshToken(
      ServiceCall call, RefreshTokenRequest request) {
    _log.finer('Call "refreshToken"');
    _log.finest(request.toDebugString());
    final completer = Completer<AuthReply>();
    _authUseCase.refreshToken(request.token).then((session) {
      final accessToken = _authUseCase.generateAccessToken(session);
      final refreshToken = _authUseCase.generateRefreshToken(session);
      completer.complete(
          AuthReply(accessToken: accessToken, refreshToken: refreshToken));
    }).catchError((onError) {
      if (onError is AuthException) {
        call.sendTrailers(
            status: StatusCode.unauthenticated, message: onError.message);
      } else {
        call.sendTrailers(status: StatusCode.unknown);
      }
      completer.completeError(onError);
    });
    return completer.future;
  }

  @override
  Future<Empty> restorePassword(
      ServiceCall call, RestorePasswordRequest request) {
    _log.finer('Call "restorePassword"');
    _log.finest(request.toDebugString());
    // TODO: implement restorePassword
    throw UnimplementedError();
  }

  @override
  Future<Empty> verifyEmail(ServiceCall call, Empty request) {
    _log.finer('Call "verifyEmail"');
    // TODO: implement verifyEmail
    throw UnimplementedError();
  }
}
