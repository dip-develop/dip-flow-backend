import 'package:injectable/injectable.dart';

import '../exceptions/exceptions.dart';
import '../interfaces/interfaces.dart';
import '../models/models.dart';
import '../repositories/repositories.dart';

@Singleton(as: UserUseCase)
class UsersUseCaseImpl implements UserUseCase {
  final AuthUseCase _authUseCase;
  final DataBaseRepository _dataBaseRepository;

  const UsersUseCaseImpl(this._authUseCase, this._dataBaseRepository);

  @override
  Future<UserModel> getUser(String token) {
    final userId = _authUseCase.getUserId(token);
    if (userId == null) {
      throw AuthException.wrongAuthData();
    }
    return _dataBaseRepository.getSessionsByUserId(userId).then((sessions) {
      if (sessions.isEmpty) {
        throw AuthException.wrongAuthData();
      }
      return _dataBaseRepository.getUser(userId).then((user) {
        if (user == null) {
          throw AuthException.wrongAuthData();
        }
        return user;
      });
    });
  }

  @override
  Future<UserModel> updateUser(UserModel user) =>
      _dataBaseRepository.putUser(user);
}
