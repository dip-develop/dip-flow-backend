import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:grpc/grpc.dart';

import '../domain/exceptions/auth_exception.dart';
import '../domain/interfaces/interfaces.dart';
import '../generated/auth_models.pb.dart';
import '../generated/auth_service.pbgrpc.dart';

class AuthService extends AuthServiceBase {
  final _usersUseCase = GetIt.I<UsersUseCase>();

  @override
  Future<AuthReply> signInByEmail(
      ServiceCall call, SignInEmailRequest request) {
    final completer = Completer<AuthReply>();
    _usersUseCase
        .signInByEmail(email: request.email, password: request.password)
        .then((session) {
      final accessToken = _usersUseCase.generateAccessToken(session);
      final refreshToken = _usersUseCase.generateRefreshToken(session);

      completer.complete(
          AuthReply(accessToken: accessToken, refreshToken: refreshToken));
    }).catchError((onError) {
      if (onError is AuthException) {
        call.sendTrailers(
            status: StatusCode.unauthenticated, message: onError.message);
      } else {
        call.sendTrailers(status: StatusCode.unknown);
      }
    });

    return completer.future;
  }

  @override
  Future<AuthReply> signUpByEmail(
      ServiceCall call, SignUpEmailRequest request) {
    final completer = Completer<AuthReply>();
    _usersUseCase
        .signUpByEmail(
            name: request.name,
            email: request.email,
            password: request.password)
        .then((session) {
      final accessToken = _usersUseCase.generateAccessToken(session);
      final refreshToken = _usersUseCase.generateRefreshToken(session);
      completer.complete(
          AuthReply(accessToken: accessToken, refreshToken: refreshToken));
    }).catchError((onError) {
      if (onError is AuthException) {
        call.sendTrailers(
            status: StatusCode.unauthenticated, message: onError.message);
      } else {
        call.sendTrailers(status: StatusCode.unknown);
      }
    });

    return completer.future;
  }

  @override
  Future<AuthReply> refreshToken(
      ServiceCall call, RefreshTokenRequest request) {
    throw UnimplementedError();
  }
}
