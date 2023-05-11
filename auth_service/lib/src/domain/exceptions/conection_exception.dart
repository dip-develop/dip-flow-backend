import 'app_exception.dart';

class ConnectionException extends AppException {
  final Uri? uri;

  ConnectionException(super.message, [this.uri]);

  factory ConnectionException.connectionNotFound() {
    return ConnectionException('Establish a connection first');
  }

  factory ConnectionException.timeout([Uri? uri]) {
    return ConnectionException('Timeout connection', uri);
  }

  factory ConnectionException.internalError({String? message, Uri? uri}) {
    return ConnectionException(
        message != null ? 'Internal error: $message' : 'Internal error', uri);
  }

  factory ConnectionException.incorrectData([Uri? uri]) {
    return ConnectionException('Incorrect data', uri);
  }

  @override
  String toString() {
    return uri != null ? '$message - ${uri!.host}' : message;
  }
}
