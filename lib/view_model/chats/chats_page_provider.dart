import 'dart:async';
import 'package:chat_group/model/chat_message.dart';
import 'package:chat_group/model/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:chat_group/view_model/services/data_base/data_base_service.dart';
import 'package:get_it/get_it.dart';

import '../../model/chat.dart';
import '../auth/auth_provider.dart';

class ChatsPageProvider with ChangeNotifier {
  AuthenticationProvider _authenticationProvider;

  late DataBaseService db;

  List<Chat>? chats;

  late StreamSubscription _chatSream;

  ChatsPageProvider(this._authenticationProvider) {
    db = GetIt.instance.get<DataBaseService>();
    getChats();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _chatSream.cancel();
    super.dispose();
  }

  void getChats() async {
    try {
      _chatSream = db
          .getChatsForUser(_authenticationProvider.chatUserData.uid)
          .listen((snapshot) async {
        chats = await Future.wait(
          snapshot.docs.map(
                (d) async {
              Map<String, dynamic> _chatData = d.data() as Map<String, dynamic>;

              // Give the members
              List<ChatUserModel> members = [];
              for (var uid in _chatData['members']) {
                DocumentSnapshot userSnapshot = await db.getUser(uid);
                Map<String, dynamic> _userData =
                userSnapshot.data() as Map<String, dynamic>;
                _userData["uid"] = userSnapshot.id;
                ChatUserModel member = ChatUserModel.fromJSON(_userData);
                members.add(member); // Add the member to the list
              }

              // Give the last chat
              List<ChatMessageModel> messages = [];
              QuerySnapshot chatMessage = await db.getLastMessageOfChat(d.id);
              if (chatMessage.docs.isNotEmpty) {
                Map<String, dynamic> messageData =
                chatMessage.docs.first.data()! as Map<String, dynamic>;

                ChatMessageModel chatMessageModel =
                ChatMessageModel.fromJSON(messageData);
                messages.add(chatMessageModel);
              }



              return Chat(
                uid: d.id,
                currentUserUid: _authenticationProvider.chatUserData.uid,
                members: members,
                messages: messages,
                activity: _chatData['is_activity'],
                group: _chatData['is_group'],
              );
            },
          ).toList(),
        );
        notifyListeners();
      });
    } catch (e) {
      print('error while loading chat');
      print(e);
    }
  }

}
