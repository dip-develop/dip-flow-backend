import 'app_exception.dart';

class AuthException extends AppException {
  AuthException(super.message);

  factory AuthException.wrongEmailData() =>
      AuthException('Email or password is not correct');

  factory AuthException.doubleAuthData() => AuthException(
      'Such data is already registered in the system. Perform authorization.');

  factory AuthException.wrongAuthData() =>
      AuthException('Authorization data is not correct');
}
