

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/chat/cubits/chat_list_states.dart';
import 'package:social_app/features/chat/cubits/chat_states.dart';
import 'package:social_app/features/chat/data/chat_repo.dart';
import 'package:social_app/models/chat_room.dart';
class ChatListCubit extends Cubit<ChatListState>{
  final ChatRepo chatRepo;
  StreamSubscription? _roomsSub;
  ChatListCubit({required this.chatRepo}) : super(ChatListInitial());

  void loadChatRooms(String currentUserId){
    emit(ChatListLoading());
    _roomsSub?.cancel();
    _roomsSub = chatRepo.fetchChatRooms(currentUserId).listen(
      (snapshot){
        final rooms = snapshot.docs.map((doc) => ChatRoom.fromDocument(
          doc.id,
          doc.data() as Map<String, dynamic>,
        ) ).toList();
        emit(ChatListLoaded(rooms));
      },
      onError: (e) =>emit(ChatListError(e.toString())),
    );
  }

  @override
  Future<void> close() {
    _roomsSub?.cancel();
    return super.close();
  }

}