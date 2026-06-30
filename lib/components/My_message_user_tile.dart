import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final String name;
  final String message;
  final String profileImg;
  final void Function()? onTap;
  final DateTime time;
  const ChatTile({super.key, required this.name, required this.message, required this.onTap, required this.profileImg, required this.time});

  String _formatTime(DateTime time){
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final now = DateTime.now();
    final diff = now.difference(time);

    if(diff.inSeconds < 60) return 'just now';
    if(diff.inHours < 24) return '$hour:$minute';
    if(diff.inDays < 7) return '${diff.inDays}days ago ';
    if(diff.inDays < 30) return '${(diff.inDays/7).floor()}w ago ';
    if(diff.inDays < 365) return '${(diff.inDays/30).floor()} mo ago';


    return '${(diff.inDays / 365).floor()}y ago';
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.primary,width: .6)),
        ),
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: profileImg,
              imageBuilder: (context, ImageProvider) {
                return CircleAvatar(
                  radius: 30,
                  backgroundImage: ImageProvider,
                );
              },
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => CircleAvatar(radius: 40, child: Icon(Icons.person),),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                  ),
                  Text(
                    message,
                    style: TextStyle(color: Colors.grey[600])
                  )
                ],
              ),
            ),
            if(time != null)
            Text(
              _formatTime(time), 
              style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary)
            )
          ],
        ),
      ),
    );
  }
}