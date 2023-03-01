import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:grpc/grpc.dart';

import 'generated/auth.pbgrpc.dart';

class AuthService extends AuthServiceBase {
  @override
  Future<AuthReply> signInByEmail(
      ServiceCall call, SignInEmailRequest request) {
    return Future.value(AuthReply());
  }

  bool _checkToken(ServiceCall call) {
    final token =
        call.headers?['Authorization']?.replaceAll('Bearer', '').trim();

    if (token == null) return false;
    final jwt = JWT.decode(token);

    return true;
  }
}
