import 'package:social_app/features/auth/domain/entities/app_user.dart';

class ProfileUser extends AppUser{
  final String bio;
  final String profileImgUrl; 
  final List<String> followers;
  final List<String> following;

  ProfileUser( {
    required this.bio, 
    required this.profileImgUrl, 
    required super.uid, 
    required super.email, 
    required super.name,
    required this.followers,
    required this.following
  });

  ProfileUser copyWith({
    String? newBio, 
    String? newProfileImgUrl,
    List<String>? newFollowers,
    List<String>? newFollowing
    }){
    return ProfileUser(
      bio: newBio ?? bio, 
      profileImgUrl: newProfileImgUrl ?? profileImgUrl, 
      uid: uid, 
      email: email, 
      name: name, 
      followers: newFollowers ?? followers, 
      following: newFollowing ?? following
    );
  }

  Map<String, dynamic> toMap(){
    return{ 
      'uid': uid,
      'email': email,
      'name': name,
      'bio': bio,
      'profileImgUrl': profileImgUrl,
      'followers': followers,
      'following': following
    };
  }

  factory ProfileUser.fromMap(Map<String, dynamic> map){
    return ProfileUser(
      bio: map['bio'], 
      profileImgUrl: map['profileImgUrl'] ?? '', 
      uid: map['uid'], 
      email: map['email'], 
      name: map['name'], 
      followers: List<String>.from(map['followers'] ?? []), 
      following: List<String>.from(map['following'] ?? [])
    );
  }

  
}