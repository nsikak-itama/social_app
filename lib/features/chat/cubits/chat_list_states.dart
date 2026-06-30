import 'package:social_app/models/chat_room.dart';

abstract class ChatListState {}

class ChatListInitial extends ChatListState{}

class ChatListLoading extends ChatListState{}

class ChatListLoaded extends ChatListState{
  final List<ChatRoom> chatRooms;
  ChatListLoaded(this.chatRooms);
}

class ChatListError extends ChatListState{
  final String message;
  ChatListError(this.message); 
}