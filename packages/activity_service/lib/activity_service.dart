library;

import 'dart:io';

import 'package:activity_service/src/presentation/time_tracking_service.dart';
import 'package:get_it/get_it.dart';
import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';

import 'activity_service.config.dart';

@InjectableInit()
void configureDependencies() => GetIt.instance.init();
void startServer() async {
  print('Dependency initialization');
  configureDependencies();
  print('Database initialization');
  final port = int.tryParse(Platform.environment['PORT'] ?? '') ?? 8082;
  print('Starting the time tracking server on port $port');
  final server = Server.create(services: [GetIt.I<TimeTrackingService>()]);
  await server.serve(port: port);
  print('Server started');
}
