import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/components/My_comment.dart';
import 'package:social_app/components/My_text_field.dart';
import 'package:social_app/cubits/profile_cubits.dart';
import 'package:social_app/features/auth/domain/entities/app_user.dart';
import 'package:social_app/features/posts/presentation/cubits/post_cubits.dart';
import 'package:social_app/features/posts/presentation/cubits/posts_states.dart';
import 'package:social_app/models/comment.dart';
import 'package:social_app/models/post.dart';
import 'package:social_app/models/profile_user.dart';
import 'package:social_app/pages/profile_page.dart';
import 'package:social_app/services/auth/auth_service.dart';

class MyPostTile extends StatefulWidget {
  final Post post;
  final void Function()? onDeletePressed;
  
  const MyPostTile({super.key, required this.post, required this.onDeletePressed});


  @override
  State<MyPostTile> createState() => _MyPostTileState();
}

class _MyPostTileState extends State<MyPostTile> {
  late final ProfileCubit _cubit;
  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  // currentuser
  AppUser? currentUser;

  bool isOwnPost = false;


  // post user
  ProfileUser? postUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    fetchPostUser();
    _cubit = context.read<ProfileCubit>();
  }

  void getCurrentUser() async {
    final authService = context.read<AuthService>();    
    currentUser = await authService.getCurrentUser();

    if(!mounted) return;
    isOwnPost = (widget.post.uid == currentUser!.uid);
  }

  Future<void> fetchPostUser() async {
    final fetchedUser = await profileCubit.getUserProfile(widget.post.uid);
    if(fetchedUser != null && mounted){
      setState(() {
        postUser = fetchedUser;
      });
    }
  }


  void addComment(){
    if (commentController.text.isEmpty) return;
    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(), 
      postId: widget.post.id, 
      userId: currentUser!.uid, 
      userName: currentUser!.name, 
      text: commentController.text, 
      timestamp: DateTime.now()
    );

    setState(() {
      widget.post.comments.add(newComment);
    });
    Navigator.of(context).pop();
    postCubit.addComment(widget.post.id, newComment).catchError((error){
      setState(() {
        widget.post.comments.remove(newComment);
      });
    });
  }

  @override
  void dispose() {
    commentController.dispose(); 
    super.dispose();
  }



  void toggleLikePost(){
    final isLiked = widget.post.likes.contains(currentUser?.uid ?? '');
    //optimistically like nd update 
    setState(() {
      if(isLiked){
        widget.post.likes.remove(currentUser!.uid);
      } else{
        widget.post.likes.add(currentUser!.uid);
      }
    });

    postCubit.toggleLikePost(widget.post.id, currentUser!.uid).catchError((error){
      setState(() {
        if(isLiked){
        widget.post.likes.add(currentUser!.uid);
      } else{
        widget.post.likes.remove(currentUser!.uid);
      }
      });
    });

  }

  final commentController = TextEditingController();
  void openNewCommentBox(){
    showDialog( context: context, builder: (context) => AlertDialog(
        title: Text("Add a comment"),
        content: MyTextField(
          hintText: "Comment", 
          controller: commentController, 
          obscureText: false
        ),
        actions: [ 
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("Cancel")),
          TextButton(onPressed: addComment, child: Text("Save"))
        ],
      )
    );
  }

  //SHOW OPTIONS TO DELETE
  void showOptions(){
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text("Delete Post?"),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("Cancel")),
        TextButton(onPressed: () {
          widget.onDeletePressed!();
          Navigator.of(context).pop();
          }, 
          child: Text("Delete")
        )

      ],
    ));
  }
 
  //BUILD UI
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        children: [
          //IMAGE
          GestureDetector(
            onTap: () => Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => ProfilePage(userId: widget.post.uid))).then((_) => _cubit.fetchUserProfile(widget.post.uid)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //poster image
              
                   postUser?.profileImgUrl != null && postUser!.profileImgUrl.isNotEmpty ? CachedNetworkImage(
                    imageUrl: postUser!.profileImgUrl,
                    errorWidget: (context, url, error) => Icon(Icons.person),
                    imageBuilder: (context, imageProvider) => Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: imageProvider, fit: BoxFit.cover)
                      ),
                    ),
                                 )
                   : Icon(Icons.person),
                   SizedBox(width: 10),
            
                   //name
                  Text(widget.post.userName, style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface, fontSize: 20, fontWeight: FontWeight.bold),),
              
                   Spacer(),
                  //delete post
                  if(isOwnPost)
                  GestureDetector(
                    onTap: showOptions,
                    child: Icon(Icons.delete)
                  ),
                ],
              ),
            ),
          ),
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            height: 430,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => const SizedBox(height: 430),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  width: 50,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: toggleLikePost,
                        child: Icon(
                          widget.post.likes.contains(currentUser?.uid ?? '') ? 
                          Icons.favorite
                          : Icons.favorite_border,
                         color: widget.post.likes.contains(currentUser?.uid ?? '')? 
                         Colors.red : Theme.of(context).colorScheme.primary
                        )
                      ),
                  
                  Text(widget.post.likes.length.toString(), style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                  
                    ],
                  ),
                ),


                SizedBox(width: 20),
                Container(
                  width: 50,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: openNewCommentBox,
                        child: Icon(Icons.comment, color: Theme.of(context).colorScheme.primary)
                      ),
                      Text(widget.post.comments.length.toString(), style: TextStyle(color: Theme.of(context).colorScheme.primary))
                    ],
                  ),
                ),
                Spacer(),
                Text(widget.post.timestamp.toString())
              ],
            ),
          ),
          //Caption
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
            child: Row(
              children: [
                Text(widget.post.userName, style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(width: 10),
                Text(widget.post.text)
              ],
            ),
          ),

          //COMMENT SECTION
          BlocBuilder<PostCubit, PostState>(
            builder: (context, state){
              //LOADED
              if(state is PostsLoaded){
                final post = state.posts.firstWhere((post) => (post.id == widget.post.id));
              if(post.comments.isNotEmpty){
                int showComments = post.comments.length;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: showComments,
                  itemBuilder: (context, index){
                    final comment = post.comments[index];
                    return CommentTile(
                      comment: comment, 
                      onDeletePressed: () {
                        setState(() {
                          widget.post.comments.removeWhere((c) => c.id == comment.id);
                        });
                      },
                    );
                  }
                );
              }
              }
              //LOADING
              if(state is PostUploading){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              //ERROR
              else if(state is PostsError){
                return Center(
                  child: Text(state.message),
                );
              } else {
                return SizedBox.shrink();
              }
            }
          )
        ],
      ),
    );
  }
}