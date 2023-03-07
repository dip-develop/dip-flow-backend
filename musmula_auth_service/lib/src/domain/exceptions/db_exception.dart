import 'app_exception.dart';

class DbException extends AppException {
  DbException(super.message);

  factory DbException.notInneted() {
    return DbException('Data Base not inneted');
  }

  factory DbException.notFound() {
    return DbException('Not found');
  }

  factory DbException.internalError() {
    return DbException('Internal error');
  }

  factory DbException.incorrectData() {
    return DbException('Incorrect data');
  }
}
