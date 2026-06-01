import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:social_app/components/My_search_tile.dart';
import 'package:social_app/components/My_user_tile.dart';
import 'package:social_app/cubits/profile_cubits.dart';
import 'package:social_app/cubits/profile_states.dart';
import 'package:social_app/features/search/cubits/search_cubits.dart';
import 'package:social_app/features/search/cubits/search_states.dart';
import 'package:social_app/models/profile_user.dart';
import 'package:social_app/responsive/constrained_scaffold.dart';

class SearchPage extends StatefulWidget {
  final String currentUserId;
  const SearchPage({super.key, required this.currentUserId});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final ProfileCubit _cubit;
  final TextEditingController searchController = TextEditingController();
  late final searchCubit = context.read<SearchCubits>();
  late final profileCubit = context.read<ProfileCubit>();
  ProfileUser? currentUserProfile;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController.addListener(onSearchChanged);
    loadCurrentUser();
  }

  void loadCurrentUser() async {
    final profile = await profileCubit.getUserProfile(widget.currentUserId);
    if (mounted) setState(() => currentUserProfile = profile);
  }

  Future<void> handleFollow(String targetUid) async {
    await profileCubit.toggleFollow(widget.currentUserId, targetUid);
     loadCurrentUser(); 
  }
 

  void onSearchChanged(){
    final query = searchController.text;
    searchCubit.searchUsers(query);
  }


  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
    return ConstrainedScaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: "Search users...",
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary)
          ),
        ),
      ),

      body: BlocBuilder<SearchCubits, SearchStates>(
        builder: (context, state){
        //loaded
        if(state is SearchLoaded){
          if(state.users.isEmpty){
            return const Center(
              child: Text("No users found"));
          }

          return ListView.builder(
            itemCount: state.users.length,
            itemBuilder: (context, index){
              final user = state.users[index];
              return 
              MySearchTile(
                user: user!, 
                isFollowing: currentUserProfile?.following.contains(user.uid) ?? false, 
                isOwnProfile: user.uid == widget.currentUserId, 
                onTapFollow: () => handleFollow(user.uid),
              );
            
            }
          );
        }

        //Loaded
        else if(state is SearchLoading){
          return const Center(
            child: CircularProgressIndicator());
        }

        //error
        else if(state is SearchError){
          return Center(
            child: Text(state.message),
          );
        }

        //default
        return Center(
          child: Text("Search users"),
        );
      }), backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}