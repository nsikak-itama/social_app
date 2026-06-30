import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom{
  final String chatRoomId;
  final List<String> participants;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String otherUserName;
  final String otherUserAvatar;

  ChatRoom({
    required this.chatRoomId, 
    required this.participants, 
    required this.lastMessage, 
    required this.lastMessageTime,
    required this.otherUserName,
    required this.otherUserAvatar
  });

  factory ChatRoom.fromDocument(String id, Map<String, dynamic> data){
    return ChatRoom(
      chatRoomId: id,
      participants: List<String>.from(data['participants'] ?? []),
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime: (data['lastMessageTime'] as Timestamp).toDate(), 
      otherUserName: data['otherUserName'] ?? '', 
      otherUserAvatar: data['otherUserAvatar'] ?? '',
    );
  }


  String getOtherUserId(String currentUserId){
    return participants.firstWhere((id) => id != currentUserId);
  }
}