import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:grpc/grpc.dart';

import '../domain/exceptions/auth_exception.dart';
import '../domain/interfaces/interfaces.dart';
import '../generated/auth_models.pb.dart';
import '../generated/auth_service.pbgrpc.dart';
import '../generated/google/protobuf/empty.pb.dart';
import '../generated/google/protobuf/timestamp.pb.dart';

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
      completer.completeError(onError);
    });

    return completer.future;
  }

  @override
  Future<AuthReply> refreshToken(
      ServiceCall call, RefreshTokenRequest request) {
    throw UnimplementedError();
  }

  @override
  Future<UserReply> getUser(ServiceCall call, Empty request) {
    final completer = Completer<UserReply>();
    final token = _getToken(call);
    if (token == null || !_usersUseCase.checkAccessToken(token)) {
      final error = AuthException.wrongAuthData();
      call.sendTrailers(
          status: StatusCode.invalidArgument, message: error.message);
      completer.completeError(error);
    } else {
      _usersUseCase.getUser(token).then((user) {
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

  String? _getToken(ServiceCall call) => (call.clientMetadata
              ?.map((key, value) => MapEntry(key.toLowerCase(), value))
              .containsKey('authorization') ??
          false)
      ? call.clientMetadata
          ?.map((key, value) => MapEntry(key.toLowerCase(), value))[
              'authorization']
          ?.replaceAll('Bearer', '')
          .replaceAll('bearer', '').trim()
      : null;
}
