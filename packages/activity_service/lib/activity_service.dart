library;

import 'dart:io';

import 'package:activity_service/src/presentation/time_tracking_service.dart';
import 'package:get_it/get_it.dart';
import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';

import 'activity_service.config.dart';

@InjectableInit()
void configureDependencies() => GetIt.instance.init();
void startServer() async {
  final log = Logger('activity_service');
  log.info('Dependency initialization');
  configureDependencies();
  log.info('Database initialization');
  final port = int.tryParse(Platform.environment['PORT'] ?? '') ?? 8082;
  log.info('Starting the time tracking server on port $port');
  final server = Server.create(services: [GetIt.I<TimeTrackingService>()]);
  await server.serve(port: port);
  log.info('Server started');
}
