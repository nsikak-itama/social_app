import 'package:cloud_firestore/cloud_firestore.dart';

class Comment{
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String text;
  final DateTime timestamp;

  Comment({ 
    required this.id, 
    required this.postId, 
    required this.userId,   
    required this.userName, 
    required this.text, 
    required this.timestamp
  });


  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'postId': postId,
      'userId': userId,
      'userName': userName,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp)
    };
  }


  factory Comment.fromMap(Map<String, dynamic> map){
    return Comment(
      id: map['id'], 
      postId: map['postId'], 
      userId: map['userId'], 
      userName: map['userName'], 
      text: map['text'], 
      timestamp: (map['timestamp'] as Timestamp).toDate()
    );
  }
}