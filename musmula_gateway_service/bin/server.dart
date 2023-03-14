import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';
import 'package:musmula_gateway_service/src/presentation/auth_service.dart';

import 'server.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();

void main(List<String> args) async {
  print('Dependency initialization');
  configureDependencies();

  final port = int.tryParse(Platform.environment['PORT'] ?? '') ?? 8080;
  print('Starting the gateaway server on port $port');
  final server = Server(
    [AuthService()],
    List<Interceptor>.empty(),
    /* CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]), */
  );
  await server.serve(port: port);

  print('Server started');
}
