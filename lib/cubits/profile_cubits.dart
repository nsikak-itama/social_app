import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubits/profile_states.dart';
import 'package:social_app/features/storage/storage_repo.dart'; 
import 'package:social_app/models/profile_user.dart';
import 'package:social_app/services/profile/profile_servies.dart';

class ProfileCubit extends Cubit<ProfileState>{
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo; 
 
  ProfileCubit({required this.profileRepo, required this.storageRepo}) : super(ProfileInitial());

  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());
      final user = await profileRepo.fetchUserProfile(uid);

      if(user != null){
        emit(ProfileLoaded(user));
      } else{
        emit(ProfileError("User not found"));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<ProfileUser?> getUserProfile(String uid) async{
    final user = await profileRepo.fetchUserProfile(uid);
    return user;
  }
  
  Future<void> updateProfile({required String uid, String? newBio, Uint8List? imageWebBytes, String? imageMobilePath  }) async {
    emit(ProfileLoading());

    try {
      final currentUser = await profileRepo.fetchUserProfile(uid);

      if(currentUser == null){
        emit(ProfileError("Filed to fetch for update"));
        return; 
      }
      

      // profile picture update
      String? imageDownloadUrl;
      if(imageWebBytes != null || imageMobilePath != null){
        if(imageMobilePath != null){
          imageDownloadUrl = await storageRepo.uploadProfileImageMobile(imageMobilePath, uid);
        } else if(imageWebBytes != null){
          imageDownloadUrl = await storageRepo.uploadProfileImageWeb(imageWebBytes, uid);
        }

        if(imageDownloadUrl == null){
          emit(ProfileError("Failed to upload image"));
        }
      }

      //update new profile
      final updatedProfile = currentUser.copyWith(newBio: newBio ?? currentUser.bio, newProfileImgUrl: imageDownloadUrl ?? currentUser.profileImgUrl);

      // update in repo
      await profileRepo.updateProfile(updatedProfile);

      // re-fetch updated profile
      await fetchUserProfile(uid);
    } catch (e) {
      emit(ProfileError("Error updating profile: " + e.toString()) );
    }
  }

  Future<void> toggleFollow(String currentUserId, String targetUserId) async{
    try {
      await profileRepo.toggleFollowing(currentUserId, targetUserId);

      await fetchUserProfile(targetUserId);
    } catch (e) {
      emit(ProfileError("Error toggling Follow: $e"));
    }
  }
}