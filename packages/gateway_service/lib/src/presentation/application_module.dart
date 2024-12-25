import 'dart:io';

import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import '../generated/auth_service.pbgrpc.dart';
import '../generated/time_tracking_service.pbgrpc.dart';
import '../generated/user_service.pbgrpc.dart';

@module
abstract class ApplicationModule {
  final _log = Logger('ApplicationModule');

  @lazySingleton
  AuthServiceClient authServiceClient() {
    final authIP = Platform.environment['USER_SERVICE_IP'] ?? '127.0.0.1';
    final authPort =
        int.tryParse(Platform.environment['USER_SERVICE_PORT'] ?? '') ?? 8081;
    _log.info('Starting the auth client at $authIP:$authPort');
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
    final authIP = Platform.environment['USER_SERVICE_IP'] ?? '127.0.0.1';
    final authPort =
        int.tryParse(Platform.environment['USER_SERVICE_PORT'] ?? '') ?? 8081;
    _log.info('Starting the user client at $authIP:$authPort');
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
        Platform.environment['ACTIVITY_SERVICE_IP'] ?? '127.0.0.1';
    final timeTrackingPort =
        int.tryParse(Platform.environment['ACTIVITY_SERVICE_PORT'] ?? '') ??
            8082;
    _log.info(
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
