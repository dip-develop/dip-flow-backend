import 'package:injectable/injectable.dart';

import '../exceptions/exceptions.dart';
import '../interfaces/interfaces.dart';
import '../models/models.dart';
import '../repositories/repositories.dart';

@Singleton(as: ProfileUseCase)
class ProfileUseCaseImpl implements ProfileUseCase {
  final AuthUseCase _authUseCase;
  final DataBaseRepository _dataBaseRepository;

  const ProfileUseCaseImpl(this._authUseCase, this._dataBaseRepository);

  @override
  Future<ProfileModel> getProfile(String token) {
    final userId = _authUseCase.getUserId(token);
    if (userId == null) {
      throw AuthException.wrongAuthData();
    }
    return _dataBaseRepository.getSessionsByProfileId(userId).then((sessions) {
      if (sessions.isEmpty) {
        throw AuthException.wrongAuthData();
      }
      return _dataBaseRepository.getProfile(userId).then((user) {
        if (user == null) {
          throw AuthException.wrongAuthData();
        }
        return user;
      });
    });
  }

  @override
  Future<ProfileModel> updateProfile(ProfileModel user) =>
      _dataBaseRepository.putProfile(user);
}
