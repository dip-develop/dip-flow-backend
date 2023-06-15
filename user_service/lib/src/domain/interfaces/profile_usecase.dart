import '../models/models.dart';

abstract class ProfileUseCase {
  Future<ProfileModel> getProfile(String token, String deviceId);
  Future<ProfileModel> updateProfile(ProfileModel user);
}
