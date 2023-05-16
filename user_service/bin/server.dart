import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';
import 'package:user_service/src/presentation/auth_service.dart';
import 'package:user_service/src/presentation/user_service.dart';

import 'server.config.dart';

@InjectableInit()
void configureDependencies() => GetIt.instance.init();

void main(List<String> args) async {
  print('Database initialization');
  print('Dependency initialization');
  configureDependencies();

  final serverPort = int.tryParse(Platform.environment['PORT'] ?? '') ?? 8081;
  print('Starting the auth server on port $serverPort');
  final server = Server(
    [GetIt.I<AuthService>(), GetIt.I<UserService>()],
    List<Interceptor>.empty(),
    /* CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]), */
  );
  await server.serve(port: serverPort);

  print('Server started');
}
