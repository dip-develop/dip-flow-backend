import 'dart:io';

import 'package:gateway_service/src/presentation/profile_service.dart';
import 'package:gateway_service/src/presentation/time_tracking_service.dart';
import 'package:get_it/get_it.dart';
import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';
import 'package:gateway_service/src/presentation/auth_service.dart';

import 'server.config.dart';

@InjectableInit()
void configureDependencies() => GetIt.instance.init();

void main(List<String> args) async {
  print('Dependency initialization');
  configureDependencies();

  final port = int.tryParse(Platform.environment['PORT'] ?? '') ?? 8080;
  print('Starting the gateaway server on port $port');
  final server = Server.create(services: [
    GetIt.I<AuthService>(),
    GetIt.I<ProfileService>(),
    GetIt.I<TimeTrackingService>(),
  ]);
  await server.serve(port: port);
  print('Server started');
}
