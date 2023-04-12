import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';
import 'package:theteam_gateway_service/src/presentation/auth_service.dart';
import 'package:theteam_gateway_service/src/presentation/time_tracking_service.dart';

import 'server.config.dart';

@InjectableInit()
void configureDependencies() => GetIt.instance.init();

void main(List<String> args) async {
  print('Dependency initialization');
  configureDependencies();

  final port = int.tryParse(Platform.environment['PORT'] ?? '') ?? 8080;
  print('Starting the gateaway server on port $port');
  final server = Server(
    [
      GetIt.I<AuthService>(),
      GetIt.I<TimeTrackingService>(),
    ],
    List<Interceptor>.empty(),
    /* CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]), */
  );
  await server.serve(port: port);

  print('Server started');
}
