import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/models/profile_user.dart';
import 'package:social_app/services/profile/profile_servies.dart';

class FirebaseProfileRepo implements ProfileRepo{
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override 
  Future<ProfileUser?> fetchUserProfile(String uid) async{ 
    try {
      final userDoc = await firebaseFirestore.collection('users').doc(uid).get();
      if(userDoc.exists){
        final userData = userDoc.data();
        if(userData != null){
          final followers = List<String>.from(userData['followers'] ?? []);
          final following = List<String>.from(userData['following'] ?? []);
          
          return ProfileUser(
            bio: userData['bio'] ?? '',
            profileImgUrl: userData['profileImgUrl'] ?? '',
            uid: uid,
            email: userData['email'] ?? '',
            name: userData['name'] ?? '', 
            followers: followers, 
            following: following,
          );
        }
      }
      throw Exception('User not found');
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  @override
  Future<void> updateProfile(ProfileUser updatedProfile) async {
   try {
     await firebaseFirestore .collection('users').doc(updatedProfile.uid).update({
      'bio' : updatedProfile.bio,
      'profileImgUrl' : updatedProfile.profileImgUrl,
      });
   } catch (e) {
    throw Exception(e);
   }
  }
  
  @override
  Future<void> toggleFollowing(String currentUid, String targetUid) async {
    try {
      final currentUserDoc = await firebaseFirestore.collection('users').doc(currentUid).get();
      final targetUserDoc = await firebaseFirestore.collection('users').doc(targetUid).get();

      if(currentUserDoc.exists && targetUserDoc.exists){
        final currentUserData = currentUserDoc.data();
        final targetUserData = targetUserDoc.data();

        if(currentUserData != null && targetUserData != null){
          final List<String> curretFollowing = List<String>.from(currentUserData['following'] ?? []);

          if(curretFollowing.contains(targetUid)){
            //unfollow
            await firebaseFirestore.collection('users').doc(currentUid).update({'following': FieldValue.arrayRemove([targetUid])});

            await firebaseFirestore.collection('users').doc(targetUid).update({'followers': FieldValue.arrayRemove([currentUid])});
          } else{
            //follow
            await firebaseFirestore.collection('users').doc(currentUid).update({'following': FieldValue.arrayUnion([targetUid])});
            await firebaseFirestore.collection('users').doc(targetUid).update({'followers': FieldValue.arrayUnion([currentUid])});
          }
        } 
      }
    } catch (e) {
      return;
    }
  }
}