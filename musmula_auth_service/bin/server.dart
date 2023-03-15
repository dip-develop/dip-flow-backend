import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';
import 'package:musmula_auth_service/src/presentation/auth_service.dart';

import 'server.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() => getIt.init();

void main(List<String> args) async {
  print('Database initialization');
  print('Dependency initialization');
  await configureDependencies();

  final serverPort = int.tryParse(Platform.environment['PORT'] ?? '') ?? 8081;
  print('Starting the auth server on port $serverPort');
  final server = Server(
    [AuthService()],
    List<Interceptor>.empty(),
    /* CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]), */
  );
  await server.serve(port: serverPort);

  print('Server started');
}
