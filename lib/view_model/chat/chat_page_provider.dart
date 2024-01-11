import 'dart:async';
import 'package:chat_group/model/chat_message.dart';
import 'package:chat_group/view_model/auth/auth_provider.dart';
import 'package:chat_group/view_model/services/cloud_storage/cloud_storage_service.dart';
import 'package:chat_group/view_model/services/data_base/data_base_service.dart';
import 'package:chat_group/view_model/services/media/media_service.dart';
import 'package:chat_group/view_model/services/navigation/navigation_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get_it/get_it.dart';

//check if it is okay

class ChatPageProvider with ChangeNotifier {
  late DataBaseService db;
  late CloudStorageService storageService;
  late MediaService mediaService;
  late NavigationService navigationService;

  AuthenticationProvider _authenticationProvider;
  ScrollController _messageViewController;

  late StreamSubscription _messagesStream;
  late StreamSubscription _keyBoardVisibilityStream;
  late KeyboardVisibilityController _keyboardVisibilityController;

  String _chatId;
  List<ChatMessageModel>? messages;

  String? _message;
  String get message {
    return message;
  }

  void set message(String value) {
    _message = value;
  }

  ChatPageProvider(
      this._chatId, this._authenticationProvider, this._messageViewController) {
    db = GetIt.instance.get<DataBaseService>();
    storageService = GetIt.instance.get<CloudStorageService>();
    mediaService = GetIt.instance.get<MediaService>();
    navigationService = GetIt.instance.get<NavigationService>();
    _keyboardVisibilityController = KeyboardVisibilityController();
    listenToChat();
    listToKeyBoardChanges();
  }

  @override
  void dispose() {
    _messagesStream.cancel();
    super.dispose();
  }

  void deleteChat() {
    goBack();
    db.deleteChat(_chatId);
  }

  void sentTextMessage() {
    if (_message != null) {
      ChatMessageModel _messageToSent = ChatMessageModel(
        content: _message!,
        type: MessageType.TEXT,
        senderID: _authenticationProvider.chatUserData.uid,
        sentTime: DateTime.now(),
      );
      db.addMessageToChat(_chatId, _messageToSent);
    }
  }

  void sentImageMessage() async {
    try {
      PlatformFile? _file = await mediaService.pickImageFromLibrary();

      if (_file != null) {
        String? downloadURL = await storageService.saveChatImage(
            _chatId, _authenticationProvider.chatUserData.uid, _file);

        ChatMessageModel messageToSent = ChatMessageModel(
          content: downloadURL!,
          type: MessageType.IMAGE,
          senderID: _authenticationProvider.chatUserData.uid,
          sentTime: DateTime.now(),
        );
        db.addMessageToChat(_chatId, messageToSent);
      }
    } catch (e) {
      print(e);
    }
  }

  void goBack() {
    navigationService.goBack();
  }

  void listToKeyBoardChanges() {
    _keyBoardVisibilityStream =
        _keyboardVisibilityController.onChange.listen((_event) {
      db
          .updateChatData(_chatId, {"is_activity": _event})
          .then((value) {})
          .onError((error, stackTrace) {
            print(error);
          });
    });
  }

  void listenToChat() {
    try {
      _messagesStream = db.streamMessageFoChat(_chatId).listen((snapshot) {
        List<ChatMessageModel> _messages = snapshot.docs.map((m) {
          Map<String, dynamic> messageData = m.data() as Map<String, dynamic>;

          return ChatMessageModel.fromJSON(messageData);
        }).toList();

        messages = _messages;
        notifyListeners();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_messageViewController.position.hasListeners && _messageViewController.position.hasPixels) {
            _messageViewController
                .jumpTo(_messageViewController.position.maxScrollExtent);
          }
        });

        //Add Scroll to bottom Call
      });
    } catch (e) {
      print('error during listening message');
      print(e);
    }
  }
}
