import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ChatRepo {
  Future<void> sendMessage(String senderId, String receiverId, String message);
  Stream<QuerySnapshot> fetchMessages(String userId1, String userId2);
  Stream<QuerySnapshot> fetchChatRooms(String userId);
}

