import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/components/My_text_field.dart';
import 'package:social_app/cubits/profile_cubits.dart';
import 'package:social_app/cubits/profile_states.dart';
import 'package:social_app/models/profile_user.dart';
import 'package:social_app/responsive/constrained_scaffold.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  PlatformFile? imagePickedFile;
  Uint8List? webImage;
  final bioTextController = TextEditingController();

  // function to poick image
  Future<void> pickImage() async{
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      withData: kIsWeb
    );

    if(result != null){
      setState(() {
        imagePickedFile = result.files.first;

        if(kIsWeb){
          webImage = imagePickedFile!.bytes;
        }
      });
    }
  }

  // update profile function
  void updateProfile() async{
    final profileCubit = context.read<ProfileCubit>();
    final String uid = widget.user.uid;
    final imageMobilePath = kIsWeb ? null : imagePickedFile?.path;
    final imageWebBytes = kIsWeb ? imagePickedFile?.bytes : null;
    final String? newBio = bioTextController.text.isNotEmpty ? bioTextController.text : null;

    if(imagePickedFile != null || newBio != null){
      profileCubit.updateProfile(uid: uid, newBio: newBio, imageMobilePath: imageMobilePath, imageWebBytes: imageWebBytes); 
    }
    else{
      Navigator.pop(context);
    }
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      builder: (context, state){
        if(state is ProfileLoading){
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text("Uploading...")
                ],
              ),
            ),
          );
        }

        return buildEditingPage();
      }, 
      listener: (context, state){
        if(state is ProfileLoaded){
          Navigator.pop(context);
        }
      }
    );
  }

  Widget buildEditingPage(){
    return ConstrainedScaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("Edit Profile"),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(onPressed: updateProfile, icon: Icon(Icons.upload))
        ],
      ),

      body: Column(
        children: [
          Center(
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary, shape: BoxShape.circle),
              clipBehavior: Clip.hardEdge,
              
              child: (!kIsWeb && imagePickedFile != null && imagePickedFile!.path != null)
                  ? Image.file(
                    File(imagePickedFile!.path!), 
                    fit: BoxFit.cover
                    )
                  : (kIsWeb && webImage != null)
                      ? Image.memory(webImage!, fit: BoxFit.cover,)
                      : CachedNetworkImage(
                        imageUrl: widget.user.profileImgUrl,
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.person, size: 72, color: Theme.of(context).colorScheme.primary),
                        imageBuilder: (context, ImageProvider) => Image(image: ImageProvider, fit: BoxFit.cover,),
                        )
                      // Image.network(
                      //     widget.user.profileImgUrl,
                      //     fit: BoxFit.cover,
                      //     errorBuilder: (context, error, stackTrace) {
                      //       return Icon(
                      //         Icons.person,
                      //         size: 72,
                      //         color: Theme.of(context).colorScheme.primary,
                      //       );
                      //     },
                      //   ),
            ),
          ),
          SizedBox(height: 25),
          Center(
            child: MaterialButton(
              padding: EdgeInsets.all(20),
              onPressed: pickImage, 
              color: Theme.of(context).colorScheme.onPrimaryFixed, 
              child: Text("Pick an image", style: TextStyle(color: Theme.of(context).colorScheme.tertiary),),
            ),
          ),
          SizedBox(height: 10),
          Text("Bio"),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: MyTextField(
              hintText: "Enter bio..", 
              controller: bioTextController, 
              obscureText: false
            ),
          ),
        ],

      ),
      
    );
  }
}