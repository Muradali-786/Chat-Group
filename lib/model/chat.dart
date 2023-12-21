import 'package:chat_group/model/chat_message.dart';
import 'package:chat_group/model/chat_user.dart';

class Chat {
  final String uid;
  final String currentUserUid;
  final bool activity;
  final bool group;
  final List<ChatUserModel> members;
  List<ChatMessageModel> messages;

  late final List<ChatUserModel> _recepients;

  Chat({
    required this.uid,
    required this.currentUserUid,
    required this.members,
    required this.messages,
    required this.activity,
    required this.group,
  }) {
    _recepients = members.where((i) => i.uid != currentUserUid).toList();
  }

  List<ChatUserModel> recepients() {
    return _recepients;
  }

  String title() {
    return !group
        ? _recepients.first.name
        : _recepients.map((user) => user.name).join(", ");
  }

  String imageURL() {
    return !group
        ? _recepients.first.imageURL
        : "https://e7.pngegg.com/pngimages/380/670/png-clipart-group-chat-logo-blue-area-text-symbol-metroui-apps-live-messenger-alt-2-blue-text.png";
  }
}
