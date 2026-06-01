import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:social_app/components/My_drawer.dart';
import 'package:social_app/components/My_post_tile.dart';
import 'package:social_app/features/posts/presentation/cubits/post_cubits.dart';
import 'package:social_app/features/posts/presentation/cubits/posts_states.dart';
import 'package:social_app/pages/create_post_pages.dart';
import 'package:social_app/responsive/constrained_scaffold.dart';
import 'package:social_app/services/auth/auth_service.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final cubit = context.read<PostCubit>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAllPosts();
  }

  void fetchAllPosts(){
    cubit.fetchAllPosts();
  }

  void deletePost(String postId){
    cubit.deletePost(postId);
    fetchAllPosts();
  }


  void signOut(){
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      appBar: AppBar(
        title: Text("Homepage"),
        centerTitle: true,
        actions: [
          // IconButton(onPressed: signOut, icon: Icon(Icons.logout))
          IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePostPage())), icon: Icon(Icons.add),)
        ],
      ),
      drawer: MyDrawer(onLogout: signOut,),
      
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state){
          if(state is PostLoading && state is PostUploading){
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          else if(state is PostsLoaded){
            final allPosts = state.posts;

            return allPosts.isEmpty 
              ? Center(
                  child: Text("No posts yet"),
                )
              : ListView.builder(
                  itemCount: allPosts.length,
                  itemBuilder: (context, index){
                    final post = allPosts[index];

                    return Padding(
                      // padding: const EdgeInsets.symmetric(horizontal: 25),
                      padding: EdgeInsets.only(left: 25, right: 25, bottom: 25),
                      child: MyPostTile(post: post, onDeletePressed: () => deletePost(post.id)),
                    );
                  },
                );
          }

          else if(state is PostsError){
            return Center(
              child: Text(state.message),
            );
          } else {
            return SizedBox();
          }
        }
      ), backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}