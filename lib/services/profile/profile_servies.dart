import 'package:social_app/models/profile_user.dart';

abstract class ProfileRepo{
  Future<ProfileUser?> fetchUserProfile(String uid);
  Future<void> updateProfile(ProfileUser updatedProfile);
  Future<void> toggleFollowing(String currentUid, String targetUid);
}