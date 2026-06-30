import 'package:social_app/models/post.dart';

abstract class PostState {}

class PostInitial extends PostState{}

class PostLoading extends PostState{}

class PostUploading extends PostState{}

class PostsLoaded extends PostState{
   final List<Post> posts;
  PostsLoaded(this.posts);
}


class PostsError extends PostState{ 
  final String message;
  PostsError(this.message);
}

 