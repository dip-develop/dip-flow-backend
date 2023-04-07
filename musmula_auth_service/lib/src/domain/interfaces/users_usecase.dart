import '../models/models.dart';

abstract class UsersUseCase {
  Future<SessionModel> refreshToken(String token);
  Future<SessionModel> signInByEmail(
      {required String email, required String password});
  Future<SessionModel> signUpByEmail(
      {required String name, required String email, required String password});
  Future<void> deleteExpiredSessions();
  bool checkRefreshToken(String token);
  bool checkAccessToken(String token);
  String generateRefreshToken(SessionModel session);
  String generateAccessToken(SessionModel session,
      {Duration duration = const Duration(hours: 1)});
  Future<UserModel> getUser(String token);
}
