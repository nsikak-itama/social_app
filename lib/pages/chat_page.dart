import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:social_app/components/chat_bubble.dart';
import 'package:social_app/features/chat/cubits/chat_cubits.dart';
import 'package:social_app/features/chat/cubits/chat_state.dart';
import 'package:social_app/features/chat/data/firebase_chat_repo.dart';
import 'package:social_app/responsive/constrained_scaffold.dart';

class ChatPage extends StatefulWidget { 
  final String receiverEmail;
  final String receiverName;
  final String receiverId;
  const ChatPage({super.key, required this.receiverEmail, required this.receiverName, required this.receiverId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  late final ChatCubit _chatCubit;
  // String get currentUserId => auth.currentUser!.uid;
  String get currentUserId => FirebaseAuth.instance.currentUser!.uid;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _chatCubit = context.read<ChatCubit>();
    _chatCubit.loadMessages(currentUserId, widget.receiverId);
  }

  void sendMessage() async{
    if(messageController.text.trim().isEmpty) return;
    _chatCubit.sendMessage(currentUserId, widget.receiverId, messageController.text.trim());
    messageController.clear();

  }
  

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(widget.receiverName),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state){
                if(state is ChatLoading){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if(state is ChatLoaded){
                  return ListView.builder(
                    itemCount: state.messages.length,
                    itemBuilder: (context, index){
                      final message = state.messages[index];
                      final isMe = message.senderId == currentUserId;
                      return ChatBubble(message: message.content, isMe: isMe);
                    }
                  );
                }
                if(state is ChatError){
                  return Center(
                    child: Text("Error: ${state.message}"),
                  );
                }
                return SizedBox();
              }
            )
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 50, left: 8, right: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.secondary,
                      hintText: "Type a message",
                      hintStyle: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.background, width: 0)
                      )
                    ),
                  ),
                ),
                IconButton(onPressed: sendMessage, icon: Icon(Icons.send))
              ],
            ),
          )
        ],
      ),
    );
  }

  

}