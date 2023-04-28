import 'dart:io';

import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';

import '../generated/auth_service.pbgrpc.dart';
import '../generated/time_tracking_service.pbgrpc.dart';

@module
abstract class ApplicationModule {
  @lazySingleton
  AuthServiceClient authServiceClient() {
    final authIP = Platform.environment['AUTH_IP'] ?? '127.0.0.1';
    final authPort =
        int.tryParse(Platform.environment['AUTH_PORT'] ?? '') ?? 8081;
    print('Starting the auth client at $authIP:$authPort');
    final authChannel = ClientChannel(
      authIP,
      port: authPort,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );

    return AuthServiceClient(authChannel,
        options: CallOptions(timeout: Duration(seconds: 30)));
  }

  @lazySingleton
  UserServiceClient userServiceClient() {
    final authIP = Platform.environment['AUTH_IP'] ?? '127.0.0.1';
    final authPort =
        int.tryParse(Platform.environment['AUTH_PORT'] ?? '') ?? 8081;
    print('Starting the auth client at $authIP:$authPort');
    final authChannel = ClientChannel(
      authIP,
      port: authPort,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );

    return UserServiceClient(authChannel,
        options: CallOptions(timeout: Duration(seconds: 30)));
  }

  @lazySingleton
  TimeTrackingServiceClient timeTrackingServiceClient() {
    final timeTrackingIP =
        Platform.environment['TIME_TRACKING_IP'] ?? '127.0.0.1';
    final timeTrackingPort =
        int.tryParse(Platform.environment['TIME_TRACKING_PORT'] ?? '') ?? 8082;
    print(
        'Starting the time tracking client at $timeTrackingIP:$timeTrackingPort');
    final authChannel = ClientChannel(
      timeTrackingIP,
      port: timeTrackingPort,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );

    return TimeTrackingServiceClient(authChannel,
        options: CallOptions(timeout: Duration(seconds: 30)));
  }
}
