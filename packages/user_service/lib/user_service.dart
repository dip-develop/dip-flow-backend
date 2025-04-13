library;

import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import 'src/presentation/auth_service.dart';
import 'src/presentation/user_service.dart';
import 'user_service.config.dart';

@InjectableInit()
void configureDependencies() => GetIt.instance.init();

void startServer() async {
  final log = Logger('gateway_service');
  log.info('Dependency initialization');
  configureDependencies();
  log.info('Database initialization');
  final serverPort = int.tryParse(Platform.environment['PORT'] ?? '') ?? 8081;
  log.info('Starting the auth server on port $serverPort');
  final server = Server.create(services: [
    GetIt.I<AuthService>(),
    GetIt.I<UserService>(),
  ]);
  await server.serve(port: serverPort);
  log.info('Server started');
}
