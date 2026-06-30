import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/features/posts/data/post_repo.dart';
import 'package:social_app/models/comment.dart';
import 'package:social_app/models/post.dart'; 

class FirebasePostRepo implements PostRepo{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference postCollection = FirebaseFirestore.instance.collection('posts');
  @override
  Future<void> createPost(Post post) async {
   try {
     await postCollection.doc(post.id).set(post.toMap());
   } catch (e) {
     throw Exception('Error creating post: $e');
   }
  }

  @override
  Future<void> deletePost(String postId) async {
      await postCollection.doc(postId).delete();   
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    try {
      final postSnapshot = await postCollection.orderBy('timestamp', descending: true).get();
      final List<Post> allPosts = postSnapshot.docs.map((doc){
        final data = doc.data() as Map<String, dynamic>;
        return Post(
          id: data['id'], 
          uid: data['uid'], 
          text: data['text'], 
          userName: data['userName'], 
          imageUrl: data['imageUrl'], 
          timestamp: (data['timestamp'] as Timestamp).toDate(), 
          likes: List<String>.from(data['likes'] ?? []), 
          comments:(data['comments'] as List<dynamic>?) ?.map((c) => Comment.fromMap(c as Map<String, dynamic>)).toList() ?? [],
        );
      }).toList();
      return allPosts;
    } catch (e) {
      throw Exception('Error fetching posts: $e');
    }
  } 

  @override
  Future<List<Post>> fetchPostByUserId(String userId) async {
    try {
      final postsSnapshot = await postCollection.where('uid', isEqualTo: userId).get();

      final userPosts = postsSnapshot.docs.map((doc){
        final data = doc.data() as Map<String, dynamic>;
        return Post(
          id: data['id'], 
          uid: data['uid'], 
          text: data['text'], 
          userName: data['userName'], 
          imageUrl: data['imageUrl'], 
          timestamp: (data['timestamp'] as Timestamp).toDate(), 
          likes: [],
          comments: (data['comments'] as List<dynamic>?)?.map((c) => Comment.fromMap(c as Map<String, dynamic>)).toList() ?? [],
        );
      }).toList();
      return userPosts;
    } catch (e) {
      throw Exception('Error fetching user posts: $e');
    }
    
  }
  
  @override
  Future<void> toggleLikedPost(String postId, String userId) async {
    try {
      final postDoc = await postCollection.doc(postId).get();

      if(postDoc.exists){
        final data = postDoc.data() as Map<String, dynamic>;
        final List<String> likes = List<String>.from(data['likes'] ?? []);

        if(likes.contains(userId)){
          likes.remove(userId);
        } else{
          likes.add(userId);
        }

        await postCollection.doc(postId).update({'likes': likes});
      print(data);
      } else{
        throw Exception("post not found");
      }

    } catch (e) {
      throw Exception('Error toggling like: $e');
    }
  }
  
  @override
  Future<void> addComment(String postId, Comment comment) async {
    try {
      //get post document
      final postDoc = await postCollection.doc(postId).get();
      if(postDoc.exists){
        //convert object
        final post = Post.fromMap(postDoc.data() as Map<String, dynamic>);

        //add document
        post.comments.add(comment);

        //update firestore
        await postCollection.doc(postId).update({
          'comments': post.comments.map((comment) => comment.toMap()).toList()
        });
        
      } else{
        throw Exception("Post not found");
      }
    } catch (e) {
      throw Exception("Error adding comment : $e");
    }
  }
  
  @override
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      //get post document
      final postDoc = await postCollection.doc(postId).get();
      if(postDoc.exists){
        //convert object
        final post = Post.fromMap(postDoc.data() as Map<String, dynamic>);

        //remove document
        post.comments.removeWhere((comment) => comment.id == commentId);

        //update firestore
        await postCollection.doc(postId).update({
          'comments': post.comments.map((comment) => comment.toMap()).toList()
        });
      } else{
        throw Exception("Post not found");
      }
    } catch (e) {
      throw Exception("Error adding comment : $e");
    }
  }

}