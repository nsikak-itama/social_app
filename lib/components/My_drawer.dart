import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/pages/profile_page.dart';
import 'package:social_app/pages/search_page.dart';
import 'package:social_app/pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onLogout;
  const MyDrawer({super.key,required this.onLogout});

  @override
  Widget build(BuildContext context) {
  FirebaseAuth _auth = FirebaseAuth.instance;

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 50),
            Icon(Icons.person, size: 80, color: Theme.of(context).colorScheme.primary),
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
                onTap: onLogout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}