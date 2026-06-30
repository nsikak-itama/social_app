import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/components/My_message_user_tile.dart';
import 'package:social_app/features/chat/cubits/chat_list_cubit.dart';
import 'package:social_app/features/chat/cubits/chat_list_states.dart';
import 'package:social_app/models/profile_user.dart';
import 'package:social_app/pages/chat_page.dart';
import 'package:social_app/services/profile/profile_firebase_repo.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  String get currentUserId => FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ChatListCubit>().loadChatRooms(currentUserId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("Messages"),
        centerTitle: true,
      ),

      body: BlocBuilder<ChatListCubit, ChatListState>(
        builder: (context, state){
          if(state is ChatListLoading){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if(state is ChatListLoaded){
            return state.chatRooms.isEmpty? 
            Center(
              child: Text("No messages"),
            ) : ListView.builder(
              itemCount: state.chatRooms.length,
              itemBuilder: (context, index){
                final room = state.chatRooms[index];
                final otherUserId = room.getOtherUserId(currentUserId);

                return FutureBuilder<ProfileUser?>(
                  future: FirebaseProfileRepo().fetchUserProfile(otherUserId), 
                  builder: (context, snapshot){
                    if (snapshot.data == null) return const SizedBox();
                    final otherUser = snapshot.data;
                    return ChatTile(
                      name: otherUser!.name, 
                      message: room.lastMessage, 
                      profileImg: otherUser.profileImgUrl, 
                      onTap:() => Navigator.push(
                        context, MaterialPageRoute(
                          builder: (context) => ChatPage(
                            receiverEmail: otherUser.email, 
                            receiverName: otherUser.name, 
                            receiverId: otherUserId
                          )
                        )
                      ).then((_) => context.read<ChatListCubit>().loadChatRooms(currentUserId)), 
                      time: room.lastMessageTime,
                    );
                  }
                );
              }
            );
          }

          if(state is ChatListError){
            print(state.message);
            return Center(
              child: Text("Error: ${state.message}"),
            );
          }

          return const SizedBox();
        }
      ),
    );
  }
}