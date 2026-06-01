import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/posts/data/post_repo.dart';
import 'package:social_app/features/posts/presentation/cubits/posts_states.dart';
import 'package:social_app/features/storage/storage_repo.dart';
import 'package:social_app/models/comment.dart';
import 'package:social_app/models/post.dart';

class PostCubit  extends Cubit<PostState>{ 
  final PostRepo postRepo;
  final StorageRepo storageRepo; 

  PostCubit({required this.postRepo, required this.storageRepo}) : super(PostInitial());

  //create a post
  Future<void> createPost(Post post, {String? imagePath, Uint8List? imageBytes}) async{
    try {
    emit(PostUploading());
    String? imageUrl; 
        //image upload for mobile platforms
    if(imagePath != null){
      emit(PostUploading());
      imageUrl = await storageRepo.uploadPostImageMobile(imagePath, post.id);
    }

    //image uploads for web platforms
    else if(imageBytes != null){
      emit(PostUploading());
      imageUrl = await storageRepo.uploadPostImageWeb(imageBytes, post.id);
    }

    final newPost= post.copyWith(imageUrl: imageUrl);

    postRepo.createPost(newPost);
    final posts = await postRepo.fetchAllPosts();
    emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError("Failed to create post: $e"));
    }
  }
  
  //fetch all posts
  Future<void> fetchAllPosts() async{
    try {
      emit(PostLoading());
      final posts = await postRepo.fetchAllPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError('Failed to fetch posts: $e'));
    }
  }

  //delete a post
  Future<void> deletePost(String postId) async{
    try {
      await postRepo.deletePost(postId); 
    } catch (e) {
      emit(PostsError('Failed to delete post: $e'));
    }
  }

  Future<void> toggleLikePost(String postId, String userId) async{
    try {
      await postRepo.toggleLikedPost(postId, userId);
    } catch (e) {
      emit(PostsError("Failed to toggle like: $e"));
    }
  } 

  Future<void> addComment(String postId, Comment comment) async { 
    try {
      await postRepo.addComment(postId, comment);

      await fetchAllPosts();
    } catch (e) {
      emit(PostsError("Failed to add comment: $e"));
    }
  }

  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await postRepo.deleteComment(postId, commentId);

      await fetchAllPosts();
    } catch (e) {
      emit(PostsError("failed to delete comment: $e")); 
    }
  }


  



}