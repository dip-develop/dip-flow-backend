import '../models/models.dart';

abstract class DataBaseRepository {
  void init();
  bool get isInneted;
  Future<ProfileModel> putProfile(ProfileModel profile);
  Future<ProfileModel?> getProfile(String id);
  Future<void> deleteProfile(String id);

  Future<SessionModel> putSession(SessionModel session);
  Future<SessionModel?> getSession(String id);
  Future<List<SessionModel>> getSessionsBy(String profileId, String deviceId);
  Future<List<SessionModel>> getExpiredSessions();
  Future<void> deleteSession(String id);
  Future<void> deleteSessions(List<String> ids);

  Future<EmailAuthModel> putEmailAuth(EmailAuthModel auth);
  Future<EmailAuthModel?> getEmailAuth(String id);
  Future<EmailAuthModel?> getAuthByEmail(String email);
  Future<void> deleteEmailAuth(String id);

  Future<void> dispose();
}
