import '../models/models.dart';

abstract class UserUseCase {
  Future<UserModel> getUser(String token);
  Future<UserModel> updateUser(UserModel user);
}
