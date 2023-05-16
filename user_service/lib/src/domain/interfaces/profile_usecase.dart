import '../models/models.dart';

abstract class ProfileUseCase {
  Future<ProfileModel> getProfile(String token);
  Future<ProfileModel> updateProfile(ProfileModel user);
}
