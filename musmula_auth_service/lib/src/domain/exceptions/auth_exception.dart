import 'app_exception.dart';

class AuthException extends AppException {
  AuthException(super.message);

  factory AuthException.wrongEmailData() {
    return AuthException('Email or password is not correct');
  }

  factory AuthException.doubleAuthData() {
    return AuthException(
        'Such data is already registered in the system. Perform authorization.');
  }
}
