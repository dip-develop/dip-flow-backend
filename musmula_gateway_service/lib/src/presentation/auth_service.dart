import 'dart:async';
import 'dart:io';

import 'package:grpc/grpc.dart';

import '../generated/auth_models.pb.dart';
import '../generated/auth_service.pbgrpc.dart';
import '../generated/gate_service.pbgrpc.dart';

class AuthService extends GateServiceBase {
  late final AuthServiceClient _client;

  AuthService() {
    final authIP = Platform.environment['AUTH_IP'] ?? '127.0.0.1';
    final authPort =
        int.tryParse(Platform.environment['AUTH_PORT'] ?? '') ?? 8081;
    print('Starting the auth client at $authIP:$authPort');
    final authChannel = ClientChannel(
      authIP,
      port: authPort,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );

    _client = AuthServiceClient(authChannel,
        options: CallOptions(timeout: Duration(seconds: 30)));
  }

  @override
  Future<AuthReply> signInByEmail(
          ServiceCall call, SignInEmailRequest request) =>
      _client.signInByEmail(
          SignInEmailRequest(email: request.email, password: request.password));

  @override
  Future<AuthReply> signUpByEmail(
          ServiceCall call, SignUpEmailRequest request) =>
      _client.signUpByEmail(request);

  @override
  Future<AuthReply> refreshToken(
          ServiceCall call, RefreshTokenRequest request) =>
      _client.refreshToken(request);
}
