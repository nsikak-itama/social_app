import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/auth/domain/entities/app_user.dart';
import 'package:social_app/features/posts/presentation/cubits/post_cubits.dart';
import 'package:social_app/models/comment.dart';
import 'package:social_app/services/auth/auth_service.dart';

class CommentTile extends StatefulWidget {
  final Comment comment;
  final void Function()? onDeletePressed;
  const CommentTile({super.key, required this.comment, required this.onDeletePressed});

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {

  AppUser?  currentUser;
  bool isOwnPost = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final authService = context.read<AuthService>();
    final user = await authService.getCurrentUser();
    if(user != null){
      setState(() {
        currentUser = user;
        isOwnPost = (widget.comment.userId == currentUser!.uid);
      });
    }
  }


  void showOptions() {
    final postCubit =  context.read<PostCubit>();
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text("Delete Comment?"),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("Cancel")),

        TextButton(onPressed: () {
          Navigator.of(context).pop();
          widget.onDeletePressed?.call();

          postCubit.deleteComment(widget.comment.postId, widget.comment.id);
          }, 
          child: Text("Delete")
        )

      ],
    ));
  } 



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Text(widget.comment.userName, style: TextStyle(fontWeight: FontWeight.bold),), 
          SizedBox(width: 10),
          Text(widget.comment.text),

          Spacer(),

          if(isOwnPost)
            GestureDetector(
              onTap: showOptions,
              child: Icon(Icons.more_horiz, color: Theme.of(context).colorScheme.primary,)
            )
          
        ],
      ),
    );
  }
}