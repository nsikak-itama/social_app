import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubits/profile_cubits.dart';
import 'package:social_app/models/profile_user.dart';
import 'package:social_app/pages/profile_page.dart';

class MySearchTile extends StatelessWidget {
  final ProfileUser user;
  final void Function()? onTapFollow;
  final bool isFollowing;
  final bool isOwnProfile;

  const MySearchTile({
    super.key, required this.user, required this.onTapFollow, required this.isFollowing, required this.isOwnProfile
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: user.profileImgUrl.isNotEmpty ? 
      CachedNetworkImage(
        imageUrl: user.profileImgUrl,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          backgroundImage: imageProvider,
        ),
        errorWidget: (context, url, error) => const CircleAvatar(
          child: Icon(Icons.person),
        ),
      ) 
      : 
      CircleAvatar(child: Icon(Icons.person)),
      title: Text(user.name),
      subtitle: Text(user.email),
      subtitleTextStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
      trailing: isOwnProfile ? 
      null 
      : 
      MaterialButton(
        color: isFollowing ? Theme.of(context).colorScheme.primary : Colors.blue,
        onPressed: onTapFollow,
        child: Text(isFollowing? "Unfollow" : "Follow", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        ),

      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(userId: user.uid))).then((_) => context.read<ProfileCubit>().fetchUserProfile(user.uid)),
    );
  }
}