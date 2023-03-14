import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';
import 'package:musmula_gateway_service/src/generated/gate_service.pbgrpc.dart';

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
    [],
    List<Interceptor>.empty(),
    /* CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]), */
  );
  await server.serve(port: port);

  final authIP = Platform.environment['AUTH_IP'] ?? '127.0.0.1';
  final authPort =
      int.tryParse(Platform.environment['AUTH_PORT'] ?? '') ?? 8081;
  print('Starting the auth client at $authIP:$authPort');
  final authChannel = ClientChannel(
    authIP,
    port: authPort,
    options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
  );

  final stub = GateServiceClient(authChannel,
      options: CallOptions(timeout: Duration(seconds: 30)));

  print('Server started');
}
