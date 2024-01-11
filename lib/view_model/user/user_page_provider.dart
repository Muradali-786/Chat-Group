import 'package:chat_group/model/chat.dart';
import 'package:chat_group/view/chat_1v1/chat_page.dart';
import 'package:chat_group/view_model/auth/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import '../../model/chat_user.dart';
import '../services/data_base/data_base_service.dart';
import '../services/navigation/navigation_service.dart';

class UserPageProvider with ChangeNotifier {
  late AuthenticationProvider _auth;
  late DataBaseService _dataBaseService;
  late NavigationService _navigationService;

  List<ChatUserModel>? users;

  late List<ChatUserModel> _selectedUser;

  List<ChatUserModel> get selectedUser {
    return _selectedUser;
  }

  UserPageProvider(this._auth) {
    _selectedUser = [];
    _dataBaseService = GetIt.instance.get<DataBaseService>();
    _navigationService = GetIt.instance.get<NavigationService>();
    getUser();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void getUser({String? name}) async {
    _selectedUser = [];

    try {
      _dataBaseService.getAllUsers(name).then(
        (snapshot) {
          users = snapshot.docs.map(
            (e) {
              Map<String, dynamic> _data = e.data() as Map<String, dynamic>;
              _data["uid"] = e.id;

              return ChatUserModel.fromJSON(_data);
            },
          ).toList();
          notifyListeners();
        },
      );
    } catch (e) {
      print('error getting user');
      print(e);
    }
  }

  void updateSelectedUser(ChatUserModel userModel) {
    if (_selectedUser.contains(userModel)) {
      _selectedUser.remove(userModel);
    } else {
      selectedUser.add(userModel);
    }
    notifyListeners();
  }

  void createChat() async {
    try {
      //create chat
      List<String> memberIds = _selectedUser.map((e) => e.uid).toList();
      memberIds.add(_auth.chatUserData.uid);

      bool isGroup = _selectedUser.length > 1;
      DocumentReference? _doc = await _dataBaseService.createChat(
          {"is_group": isGroup, "is_activity": false, "members": memberIds});

      //navigate to chat page

      List<ChatUserModel> _members = [];
      for (var uid in memberIds) {
        DocumentSnapshot _userSnapshot = await _dataBaseService.getUser(uid);
        Map<String, dynamic> userData =
            _userSnapshot.data() as Map<String, dynamic>;
        userData["uid"] = _userSnapshot.id;
        _members.add(
          ChatUserModel.fromJSON(
            userData,
          ),
        );
      }
      ChatPage _chatPage = ChatPage(
        chat: Chat(
          uid: _doc!.id,
          currentUserUid: _auth.chatUserData.uid,
          members: _members,
          messages: [],
          activity: false,
          group: isGroup,
        ),
      );
      _selectedUser=[];
      notifyListeners();
      _navigationService.navigateToPage(_chatPage);
    } catch (e) {
      print('error creating chat');
      print(e);
    }
  }
}
