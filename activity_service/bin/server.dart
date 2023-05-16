import 'dart:io';

import 'package:activity_service/src/presentation/time_tracking_service.dart';
import 'package:get_it/get_it.dart';
import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';

import 'server.config.dart';

@InjectableInit()
Future<void> configureDependencies() => GetIt.instance.init();
void main(List<String> args) async {
  print('Database initialization');
  print('Dependency initialization');
  await configureDependencies();

  final port = int.tryParse(Platform.environment['PORT'] ?? '') ?? 8082;
  print('Starting the time tracking server on port $port');
  final server = Server(
    [GetIt.I<TimeTrackingService>()],
    List<Interceptor>.empty(),
    /* CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]), */
  );
  await server.serve(port: port);
  print('Server started');
}
