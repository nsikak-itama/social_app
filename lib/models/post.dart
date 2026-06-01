import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/models/comment.dart';

class Post{
  final String id;
  final String uid;
  final String text;
  final String userName;
  final String imageUrl;
  final DateTime timestamp;
  final List<String> likes;
  final List<Comment> comments;

  Post({
    required this.id, 
    required this.uid, 
    required this.text, 
    required this.userName, 
    required this.imageUrl, 
    required this.timestamp,
    required this.likes,
    required this.comments
  });

  Post copyWith({String? imageUrl, String? text}){
    return Post(
      id: id, 
      uid: uid, 
      text: text ?? this.text, 
      userName: userName, 
      imageUrl: imageUrl ?? this.imageUrl, 
      timestamp: timestamp,
      likes: likes,
      comments: comments
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'uid': uid,
      'text': text,
      'userName': userName,
      'imageUrl': imageUrl,
      'timestamp': Timestamp.fromDate(timestamp),
      'likes': likes,
      'comments': comments.map((comment) => comment.toMap()).toList()
    };
  }

  factory Post.fromMap(Map<String, dynamic> map){
    final List<Comment> comments = (map['comments'] as List<dynamic>?)?.map((commentMap) => Comment.fromMap(commentMap)).toList() ?? [];
    return Post(
      id: map['id'], 
      uid: map['uid'],
      text: map['text'], 
      userName: map['userName'], 
      imageUrl: map['imageUrl'], 
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      likes: List<String>.from(map['likes'] ?? []),
      comments: comments
    );
  }

} 