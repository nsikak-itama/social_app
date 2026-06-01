import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/components/My_text_field.dart';
import 'package:social_app/features/auth/domain/entities/app_user.dart';
import 'package:social_app/features/posts/presentation/cubits/post_cubits.dart';
import 'package:social_app/features/posts/presentation/cubits/posts_states.dart';
import 'package:social_app/models/post.dart';
import 'package:social_app/models/profile_user.dart';
import 'package:social_app/responsive/constrained_scaffold.dart';
import 'package:social_app/services/auth/auth_service.dart';
import 'package:social_app/services/profile/profile_firebase_repo.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  
  PlatformFile? imagePickedFile;

  Uint8List? webImage;

  final textController = TextEditingController();


  ProfileUser? currentUser;


  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }
 
  void getCurrentUser() async {
    final authUser = await AuthService().getCurrentUser();

    if(authUser == null) return;

    final profileUser = await FirebaseProfileRepo().fetchUserProfile(authUser.uid);

    if(authUser != null){
      setState(() {
        currentUser = profileUser;
      });
    }

  }

 

  Future<void> picImage() async{
    final result = await FilePicker.pickFiles(type: FileType.image, withData: kIsWeb);
    if(result != null){
      setState(() {
        imagePickedFile = result.files.first;

        if(kIsWeb){
          webImage = imagePickedFile!.bytes;
        }
      });
    }
  }

  Future<void> uploadPost() async{
    if(imagePickedFile == null || textController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Both image and caption are required")));
      return;
    }

    if(currentUser == null){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not found"))
      );
      return;
    }


    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(), 
      uid: currentUser!.uid, 
      text: textController.text, 
      userName: currentUser!.name, 
      imageUrl: '', 
      timestamp: DateTime.now(), 
      likes: [],
      comments: []
    );



    final postCubit = context.read<PostCubit>(); 
    // web upload
    if(kIsWeb){
      await postCubit.createPost(newPost, imageBytes: imagePickedFile?.bytes);
    }
    //mobile upload
    else{
     await postCubit.createPost(newPost, imagePath: imagePickedFile?.path);
    }

  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      builder: (context, state){
        if(state is PostUploading || state is PostLoading){
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (currentUser == null) {
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
        }

        return buildUpLoadingPage();
      }, 
      listener: (context, state){
        if(state is PostsLoaded){
          Navigator.pop(context);
        }
      }
    );
  }
  Widget buildUpLoadingPage(){
    return ConstrainedScaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("Create Post"),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(onPressed: uploadPost, icon: Icon(Icons.upload))
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          
          child: Column(
            children: [
              //Placehlder
              Row(
                children: [
                  CachedNetworkImage(
                     imageUrl: currentUser!.profileImgUrl,
                     placeholder: (context, url) =>  Center(child: CircularProgressIndicator()),
                     errorWidget: (context, url, error) => Icon(Icons.person, size: 72, color: Theme.of(context).colorScheme.primary),
                     imageBuilder: (context, ImageProvider) => Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: ImageProvider, 
                          fit: BoxFit.cover
                          ),
                      ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(currentUser!.name, style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary, fontSize: 26, fontWeight: FontWeight.w200),)
                ],
              ),

              SizedBox(height: 20),
             
             // pick image button
              GestureDetector(
                
                onTap: picImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  color: Theme.of(context).colorScheme.tertiary,
                  child: 
              (kIsWeb && webImage != null) ?
                Image.memory(webImage!, fit: BoxFit.cover, width: double.infinity, height: 200,)
                :
              //image prevew for web
              (!kIsWeb && imagePickedFile != null) ?
                Image.file(File(imagePickedFile!.path!)) 
                : 
                Icon(Icons.add_a_photo),
                ),
              ),
            
              //image prevew for web
        
              SizedBox(height: 20),
   
              MyTextField(
                hintText: "C A P T I O N", 
                controller: textController, 
                obscureText: false
              )
            ],
          ),
        ),
      ),
    );
  }
}