import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubits/profile_cubits.dart';
import 'package:social_app/cubits/profile_states.dart';
import 'package:social_app/features/auth/domain/entities/app_user.dart';
import 'package:social_app/models/profile_user.dart';
import 'package:social_app/pages/chat_list_page.dart';
import 'package:social_app/pages/profile_page.dart';
import 'package:social_app/pages/search_page.dart';
import 'package:social_app/pages/settings_page.dart';

class MyDrawer extends StatefulWidget {
  final void Function()? onLogout;
  const MyDrawer({super.key,required this.onLogout});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late final profileCubit = context.read<ProfileCubit>();


  ProfileUser? currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if(uid != null){
      profileCubit.fetchUserProfile(uid);
    }
  }

  

  @override
  Widget build(BuildContext context) {
  FirebaseAuth _auth = FirebaseAuth.instance;

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 50),

            BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state){
              if(state is ProfileLoaded){
                final user = state.profileUser;

                if(user.profileImgUrl.isNotEmpty){
                  return CachedNetworkImage(
                    imageUrl: user.profileImgUrl,
                    imageBuilder: (context, imageProvider){
                      return CircleAvatar(
                        radius: 40,
                        backgroundImage: imageProvider,
                      );
                    },
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => CircleAvatar(radius: 40, child: Icon(Icons.person),),
                  );
                }
              }
              return CircleAvatar(radius: 40, child: Icon(Icons.person),);
            }),
  
            SizedBox(height: 50),
            Divider(color: Theme.of(context).colorScheme.secondary),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                title: Text("Home", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
                leading: Icon(Icons.home, color: Theme.of(context).colorScheme.primary),
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                title: Text("Profile", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)),
                leading: Icon(Icons.person, color: Theme.of(context).colorScheme.primary,),
                onTap: (){
                  Navigator.of(context).pop();

                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(userId: _auth.currentUser!.uid,)));
                },
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                title: Text("Search", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)),
                leading: Icon(Icons.search, color: Theme.of(context).colorScheme.primary,),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage(currentUserId: _auth.currentUser!.uid))),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                title: Text("Messages", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)),
                leading: Icon(Icons.message, color: Theme.of(context).colorScheme.primary,),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatListPage())),
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                title: Text("Settings", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)),
                leading: Icon(Icons.settings, color: Theme.of(context).colorScheme.primary,),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage())),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                title: Text("Logout", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)),
                leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.primary,),
                onTap: widget.onLogout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}