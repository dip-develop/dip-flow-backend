import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';

import '../generated/auth_models.pb.dart';
import '../generated/auth_service.pbgrpc.dart';
import '../generated/gate_service.pbgrpc.dart';
import '../generated/google/protobuf/empty.pb.dart';

@singleton
class AuthService extends AuthGateServiceBase {
  final AuthServiceClient _authClient;

  AuthService(this._authClient);

  @override
  Future<AuthReply> signInByEmail(
          ServiceCall call, SignInEmailRequest request) =>
      _authClient.signInByEmail(
          SignInEmailRequest(email: request.email, password: request.password),
          options: CallOptions(metadata: call.clientMetadata));

  @override
  Future<AuthReply> signUpByEmail(
          ServiceCall call, SignUpEmailRequest request) =>
      _authClient.signUpByEmail(request,
          options: CallOptions(metadata: call.clientMetadata));

  @override
  Future<AuthReply> refreshToken(
          ServiceCall call, RefreshTokenRequest request) =>
      _authClient.refreshToken(request,
          options: CallOptions(metadata: call.clientMetadata));

  @override
  Future<Empty> restorePassword(
          ServiceCall call, RestorePasswordRequest request) =>
      _authClient.restorePassword(request,
          options: CallOptions(metadata: call.clientMetadata));

  @override
  Future<Empty> verifyEmail(ServiceCall call, Empty request) =>
      _authClient.verifyEmail(request,
          options: CallOptions(metadata: call.clientMetadata));
}
