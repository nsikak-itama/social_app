import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/components/My_user_tile.dart';
import 'package:social_app/cubits/profile_cubits.dart';
import 'package:social_app/cubits/profile_states.dart';
import 'package:social_app/models/profile_user.dart';
import 'package:social_app/responsive/constrained_scaffold.dart';

class FollowerPage extends StatefulWidget {
  final List<String> followers;
  final List<String> following;
  final String currentUserId;
  const FollowerPage({
    super.key, 
    required this.followers, 
    required this.following, 
    required this.currentUserId, 
    required currentUserFollowing
  });

  @override
  State<FollowerPage> createState() => _FollowerPageState();
}

class _FollowerPageState extends State<FollowerPage> {
  late final ProfileCubit _cubit;
  ProfileUser? currentUserProfile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = context.read<ProfileCubit>();
    loadCurrentUser();
  }

  void loadCurrentUser() async{
    final profile = await context.read<ProfileCubit>().getUserProfile(widget.currentUserId);
    if(mounted)  setState(() => currentUserProfile = profile);
  }

  Future<void> handleFollow(String targetUid) async {
    await context.read<ProfileCubit>().toggleFollow(widget.currentUserId, targetUid);
    // refetch current user's following list to update buttons
    loadCurrentUser();
  }

  void followPressed(){
    final profileState = _cubit.state;
    if(profileState is! ProfileLoaded){
      return;
    }
    final profileUser = profileState.profileUser; 
    final isFollowing = profileUser.followers.contains(currentUserProfile!.uid);
    _cubit.toggleFollow(currentUserProfile!.uid, widget.currentUserId);
  }

  @override 
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, 
      child: ConstrainedScaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          bottom: TabBar(
            dividerColor: Colors.transparent,
            labelColor: Theme.of(context).colorScheme.inversePrimary,
            unselectedLabelColor: Theme.of(context).colorScheme.primary,
            tabs: const [
              Tab(text: "Followers"),
              Tab(text: "Following"),
            ]
          ),
        ),

        body: TabBarView(children: [
          _buildUserList(widget.followers, "No followers", context),
          _buildUserList(widget.following, "No following anybody", context)
        ]),
      )
    );
  }

  Widget _buildUserList(List<String> uids, String emptyMessage, BuildContext context){
    return uids.isEmpty ? Center(
      child: Text(emptyMessage),
    ) : ListView.builder(
      itemCount: uids.length,
      itemBuilder: (context, index){
        final uid = uids[index];

        return FutureBuilder(
          future: context.read<ProfileCubit>().getUserProfile(uid), 
          builder: (context, snapshot){
            if(snapshot.hasData){
              final user = snapshot.data!;
              return FutureBuilder(
                future: context.read<ProfileCubit>().getUserProfile(widget.currentUserId), 
                builder: (context, currentUserSnapshot){
                  final currentUserProfile = currentUserSnapshot.data;
              return UserTile(
                user: user, 
                isFollowing: currentUserProfile?.following.contains(user.uid) ?? false, 
                isOwnProfile: user.uid == widget.currentUserId, 
                onTapFollow: () => handleFollow(user.uid),
              );
                } 
              );
            } else if(snapshot.connectionState == ConnectionState.waiting){
              return ListTile(
                title: Text("Loading..")
              );
            } else{
              return ListTile(
                title: Text("User not found..."),
              );
            }
          }
        );
      }
    );
  }
}