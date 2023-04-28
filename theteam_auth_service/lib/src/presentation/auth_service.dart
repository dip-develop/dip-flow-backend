import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';

import '../domain/exceptions/auth_exception.dart';
import '../domain/interfaces/interfaces.dart';
import '../generated/auth_models.pb.dart';
import '../generated/auth_service.pbgrpc.dart';
import '../generated/google/protobuf/empty.pb.dart';

@singleton
class AuthService extends AuthServiceBase {
  final AuthUseCase _authUseCase;

  AuthService(this._authUseCase);

  @override
  Future<AuthReply> signInByEmail(
      ServiceCall call, SignInEmailRequest request) {
    final completer = Completer<AuthReply>();
    _authUseCase
        .signInByEmail(email: request.email, password: request.password)
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

    return completer.future;
  }

  @override
  Future<AuthReply> signUpByEmail(
      ServiceCall call, SignUpEmailRequest request) {
    final completer = Completer<AuthReply>();
    _authUseCase
        .signUpByEmail(
            name: request.name,
            email: request.email,
            password: request.password)
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

    return completer.future;
  }

  @override
  Future<AuthReply> refreshToken(
      ServiceCall call, RefreshTokenRequest request) {
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
    // TODO: implement restorePassword
    throw UnimplementedError();
  }

  @override
  Future<Empty> verifyEmail(ServiceCall call, Empty request) {
    // TODO: implement verifyEmail
    throw UnimplementedError();
  }
}
