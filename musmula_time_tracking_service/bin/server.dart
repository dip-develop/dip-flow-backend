import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

import 'server.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();

void main(List<String> args) async {
  print('Database initialization');
  await Isar.initializeIsarCore(download: true);
  print('Dependency initialization');
  configureDependencies();

  final port = int.tryParse(Platform.environment['PORT'] ?? '') ?? 8082;
  print('Starting the time tracking server on port $port');
  final server = Server(
    [],
    List<Interceptor>.empty(),
    /* CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]), */
  );
  await server.serve(port: port);
  print('Server started');
}
