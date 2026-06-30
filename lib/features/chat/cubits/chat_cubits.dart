import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/chat/cubits/chat_state.dart';
import 'package:social_app/features/chat/data/chat_repo.dart';
import 'package:social_app/models/message.dart';

class ChatCubit extends Cubit<ChatState>{
  final ChatRepo chatRepo;
  StreamSubscription? _messagesSub;

  ChatCubit({required this.chatRepo}) : super(ChatInitial());

  void loadMessages(String userId1, String userId2){
    emit(ChatLoading());
    _messagesSub?.cancel();
    _messagesSub = chatRepo.fetchMessages(userId1, userId2).listen((snapshot){
      final messages = snapshot.docs.map((doc) => Message.fromDocument(doc.data() as Map<String, dynamic>)).toList();

      emit(ChatLoaded(messages));
    },
    onError: (error) => emit(ChatError(error.toString())),
    );
  }

  Future<void> sendMessage(String senderId, String receiverId, String message) async {
    try {
      await chatRepo.sendMessage(senderId, receiverId, message);
      } catch (e) {
        emit(ChatError(e.toString()));
      } 
  }

  @override
  Future<void> close(){
    _messagesSub?.cancel();
    return super.close();
  }  
}