import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  final int postCount ;
  final int followingCount;
  final int followerCount;
  final void Function()? onTap; 
  const ProfileStats({
    super.key, 
    required this.postCount, 
    required this.followingCount, 
    required this.followerCount, 
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text("Posts", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                Text(postCount.toString(), style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.inversePrimary))
              ],
            ),
          ),
      
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text("Followers", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                Text(followerCount.toString(), style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.inversePrimary))
              ],
            ),
          ),
      
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text("Following", style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                Text(followingCount.toString(), style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.inversePrimary))
              ],
            ),
          )
        ],
      ),
    );
  }
}