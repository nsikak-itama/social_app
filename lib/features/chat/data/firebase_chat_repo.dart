import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_app/features/chat/data/chat_repo.dart';
import 'package:social_app/models/message.dart';

class FirebaseChatRepo implements ChatRepo{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Stream<QuerySnapshot<Object?>> fetchChatRooms(String userId) {
    return firestore
    .collection('chat_rooms')
    .where('participants', arrayContains: userId)
    .orderBy('lastMessageTime', descending: true)
    .snapshots();
  }


  @override
  Stream<QuerySnapshot> fetchMessages(String userId1, String userId2) {
    final ids = [userId1, userId2];
    ids.sort();
    String chatRoomId = ids.join("_");
    return firestore.collection('chat_rooms').doc(chatRoomId).collection('messages').orderBy('timestamp', descending: false).snapshots();
  }

  @override
  Future<void> sendMessage(String senderId, String receiverId, String message) async {
    final ids = [senderId, receiverId];
    ids.sort();

    final chatRoomId = ids.join("_");

    await firestore.collection('chat_rooms').doc(chatRoomId).set({
      'participants': [senderId, receiverId],
      'lastMessage': message,
      'lastMessageTime': Timestamp.now(),
    }, SetOptions(merge: true));

    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(), 
      senderId: senderId, 
      receiverId: receiverId,
      content: message, 
      timestamp: Timestamp.now(), 
      senderEmail: auth.currentUser!.email!
    );

    await firestore.collection('chat_rooms').doc(chatRoomId).collection('messages').add(newMessage.toMap());
  }
  
  
 

}