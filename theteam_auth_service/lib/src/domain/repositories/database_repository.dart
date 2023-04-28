import '../models/models.dart';

abstract class DataBaseRepository {
  void init();
  Future<UserModel> putUser(UserModel user);
  Future<UserModel?> getUser(int id);
  Future<void> deleteUser(int id);

  Future<SessionModel> putSession(SessionModel session);
  Future<SessionModel?> getSession(int id);
  Future<List<SessionModel>> getSessionsByUserId(int id);
  Future<List<SessionModel>> getExpiredSessions();
  Future<void> deleteSession(int id);
  Future<void> deleteSessions(List<int> ids);

  Future<EmailAuthModel> putEmailAuth(EmailAuthModel auth);
  Future<EmailAuthModel?> getEmailAuth(int id);
  Future<EmailAuthModel?> getAuthByEmail(String email);
  Future<void> deleteEmailAuth(int id);

  void dispose();
}
