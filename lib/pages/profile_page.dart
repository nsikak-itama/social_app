import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/components/My_post_tile.dart';
import 'package:social_app/components/bio_box.dart';
import 'package:social_app/components/follow_button.dart';
import 'package:social_app/components/profile_stats.dart';
import 'package:social_app/cubits/profile_cubits.dart';
import 'package:social_app/cubits/profile_states.dart';
import 'package:social_app/features/auth/domain/entities/app_user.dart';
import 'package:social_app/features/posts/presentation/cubits/post_cubits.dart';
import 'package:social_app/features/posts/presentation/cubits/posts_states.dart';
import 'package:social_app/models/profile_user.dart';
import 'package:social_app/pages/edit_profile_page.dart';
import 'package:social_app/pages/follower_page.dart';
import 'package:social_app/services/auth/auth_service.dart';
import 'package:social_app/services/profile/profile_firebase_repo.dart';

class ProfilePage extends StatefulWidget {
  final String userId;
  const ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  late final ProfileCubit _cubit;
  AppUser? currentUser;
  bool isOwnProfile = false;
  ProfileUser? profileUser;


  //posts
  int postCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = context.read<ProfileCubit>();
    _cubit.fetchUserProfile(widget.userId);
    getCurrentUser();
  }

  void getCurrentUser() async{
    final authService = context.read<AuthService>();
    currentUser = await authService.getCurrentUser();

    setState(() {
      
    isOwnProfile = (widget.userId == currentUser?.uid);
    });

  } 

  void followButtonPressed(){
    final profileState = _cubit.state;
    if(profileState is! ProfileLoaded){
      return;
    }
    final profileUser = profileState.profileUser; 
    final isFollowing = profileUser.followers.contains(currentUser!.uid);

    _cubit.toggleFollow(currentUser!.uid, widget.userId);
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if(state is ProfileLoading){
          return Scaffold(
            body: Center(child: CircularProgressIndicator(),),
          );
        }


        // loaded
        if(state is ProfileLoaded){
            return Scaffold(
            appBar: AppBar(
              title: Text(state.profileUser.name),
              centerTitle: true,
              foregroundColor: Theme.of(context).colorScheme.primary,

              
              actions: [
                if(isOwnProfile)
                IconButton(
                  onPressed: (){Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => EditProfilePage(user: state.profileUser))
                  ).then((_) => _cubit.fetchUserProfile(widget.userId));
                   }, 
                  icon: Icon(Icons.edit) 
                )
              ],
            ),
            body: ListView(
              children: [
                Text(state.profileUser.email, style: TextStyle(color: Theme.of(context).colorScheme.primary), textAlign: TextAlign.center,),
                SizedBox(height: 25),
                CachedNetworkImage(
                   imageUrl: state.profileUser.profileImgUrl,
                   placeholder: (context, url) =>  Center(child: CircularProgressIndicator()),
                   errorWidget: (context, url, error) => Icon(Icons.person, size: 72, color: Theme.of(context).colorScheme.primary),
                   imageBuilder: (context, ImageProvider) => Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, 
                      image: DecorationImage(
                        image: ImageProvider, 
                        fit: BoxFit.cover
                        ),
                    ),
                    ),
                  ), 
                SizedBox(height: 25),

                ProfileStats(
                  postCount: postCount, 
                  followingCount: state.profileUser.following.length, 
                  followerCount: state.profileUser.followers.length, 
                  onTap: () => Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => FollowerPage(
                      followers: state.profileUser.followers, 
                      following: state.profileUser.following,
                      currentUserId: currentUser?.uid ?? '', 
                      currentUserFollowing: null, 
                    ))
                  ).then((_) => _cubit.fetchUserProfile(widget.userId)),
                ),

                SizedBox(height: 25),

                if(!isOwnProfile && currentUser != null)
                FollowButton(
                  onPressed: followButtonPressed,
                  isFollowing: state.profileUser.followers.contains(currentUser!.uid),
                ),

                SizedBox(height: 25),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Text("Bio", style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                    ],
                  ),
                ),

                SizedBox(height: 10),


                BioBox(text: state.profileUser.bio),

                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Row(
                    children: [
                      Text(
                        "Posts",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),

                BlocBuilder<PostCubit, PostState>(builder: (context, state){
                  if(state is PostsLoaded){
                    final userPosts = state.posts.where((post) => post.uid == widget.userId).toList();
                    postCount = userPosts.length;

                    return ListView.builder(
                      itemCount: postCount,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index){
                        final post = userPosts[index];

                        return MyPostTile(
                          post: post, 
                          onDeletePressed: () =>  context.read<PostCubit>().deletePost(post.id)
                        );
                      }
                    );
                  }

                  else if(state is PostLoading){
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Center(child: Text("Npo error"));
                  }
                })
              ],
            ),
          );
        }

        if(state is ProfileError){
          return Scaffold(
            body: Center(
              child: Text(state.message),
            ),
          );
        }

        return const Scaffold(
          body: SizedBox(),
        );
      }
    );
  }
}