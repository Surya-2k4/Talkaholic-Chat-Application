import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:talkaholic/models/user_profile.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:talkaholic/services/auth_service.dart';
import 'package:get_it/get_it.dart';
import 'package:talkaholic/services/database_services.dart';
import 'package:talkaholic/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



import '../models/chat.dart';


class ChatPage extends StatefulWidget {

  final UserProfile chatUser;

  const ChatPage({
    super.key,
    required this.chatUser,
    });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;
  late DatabaseServices _databaseServices;

  ChatUser? currentUser, otherUser;
  
 

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _databaseServices = _getIt.get<DatabaseServices>();

    currentUser = ChatUser(
      id:_authService.user!.uid,
      firstName: _authService.user!.displayName,
      );
      otherUser = ChatUser(
      id: widget.chatUser.uid!,
      firstName: widget.chatUser.name,
      //want to write add profile image in chat
       );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text(
          widget.chatUser.name!,
        ),
      ),
      body: _buildUI(),

    );
  }


  Widget _buildUI(){
  return StreamBuilder(
    stream:_databaseServices.getChatDdata(currentUser!.id,otherUser!.id) ,
    builder: (context, snapshot){
      Chat? chat = snapshot.data?.data();
      List<ChatMessage> messages = [];
      if(chat != null && chat.messages !=null){
        messages = _generateChatMessagesList(chat.messages!);
      }
      return DashChat(
        messageOptions: const MessageOptions(
          showOtherUsersAvatar: true,
          showTime: true,
        ),
        inputOptions: const InputOptions(
          alwaysShowSend: true,
        ),
        currentUser: currentUser!,
         onSend: _sendMessage,
          messages: messages,
          );
    });
  }

  Future<void> _sendMessage(ChatMessage chatMessage)async{
    Message message = Message(
      senderID: currentUser!.id,
      content: chatMessage.text,
      messageType: MessageType.Text,
      sentAt: Timestamp.fromDate(chatMessage.createdAt),);

      await _databaseServices.sendChatMessage(
        currentUser!.id,
        otherUser!.id,
        message,
        );
}

List<ChatMessage> _generateChatMessagesList(List<Message> messages){
  List<ChatMessage> chatMessages = messages.map((m) {
  return ChatMessage(user: m.senderID == currentUser!.id ? currentUser! :otherUser!,
  text: m.content!,
  createdAt: m.sentAt!.toDate());
}).toList();
chatMessages.sort((a, b) {
  return b.createdAt.compareTo(a.createdAt);
},);
return chatMessages;

}
}
