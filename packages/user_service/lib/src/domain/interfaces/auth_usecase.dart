import '../models/models.dart';

abstract class AuthUseCase {
  Future<SessionModel> refreshToken(String token);
  Future<SessionModel> signInByEmail({
    required String email,
    required String password,
    required String deviceId,
  });
  Future<SessionModel> signUpByEmail({
    required String name,
    required String email,
    required String password,
    required String deviceId,
  });
  Future<void> deleteExpiredSessions();
  bool checkRefreshToken(String token);
  bool checkAccessToken(String token);
  String generateRefreshToken(SessionModel session);
  String generateAccessToken(SessionModel session, {Duration duration});
  int? getUserId(String token);
}
