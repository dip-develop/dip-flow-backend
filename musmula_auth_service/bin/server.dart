import 'dart:io';

import 'package:grpc/grpc.dart';
import 'package:musmula_auth_service/src/auth_service.dart';

void main(List<String> args) async {
  final port = int.tryParse(Platform.environment['PORT'] ?? '') ?? 8080;

  final server = Server(
    [AuthService()],
    List<Interceptor>.empty(),
    CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
  );
  await server.serve(port: port);
}
