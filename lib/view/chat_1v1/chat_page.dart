import 'package:chat_group/constant/app_style/app_color.dart';
import 'package:chat_group/model/chat_message.dart';
import 'package:chat_group/utils/component/custom_list_tile.dart';
import 'package:chat_group/utils/component/top_bar.dart';
import 'package:chat_group/view_model/chat/chat_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/chat.dart';
import '../../view_model/auth/auth_provider.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;
  const ChatPage({super.key, required this.chat});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late double deviceHeight;
  late double deviceWidth;
  late AuthenticationProvider _authenticationProvider;
  late ChatPageProvider chatPageProvider;
  late ScrollController _messageListViewController;
  late GlobalKey<FormState> _messageFormState;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _messageFormState = GlobalKey<FormState>();
    _messageListViewController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    _authenticationProvider = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatPageProvider>(
          create: (_) => ChatPageProvider(this.widget.chat.uid,
              _authenticationProvider, _messageListViewController),
        ),
      ],
      child: _builtUI(),
    );
  }

  Widget _builtUI() {
    return Builder(builder: (BuildContext context) {
      chatPageProvider = context.watch<ChatPageProvider>();
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: deviceHeight * 0.98,
            width: deviceWidth * 0.97,
            padding: EdgeInsets.symmetric(
                horizontal: deviceWidth * 0.03, vertical: deviceHeight * 0.03),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                TopBar(
                  widget.chat.title(),
                  fontSize: 22,
                  primaryAction: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.delete,
                        color: AppColor.kDeepBlueColor,
                      )),
                  secondaryAction: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: AppColor.kDeepBlueColor,
                      )),
                ),
                SizedBox(height: deviceHeight * 0.02),
                _messageListView()
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _messageListView() {
    if (chatPageProvider.messages != null) {
      if (chatPageProvider.messages!.length != 0) {
        return SizedBox(
          height: deviceHeight * 0.74,
          child: ListView.builder(
              itemCount: chatPageProvider.messages!.length,
              itemBuilder: (BuildContext context, int index) {
                ChatMessageModel message = chatPageProvider.messages![index];
                bool isOwnMessage = message.senderID ==
                    _authenticationProvider.chatUserData.uid;
                return CustomChatListViewTile(
                    width: deviceWidth * 0.65,
                    deviceHeight: deviceHeight,
                    isOwnMessage: isOwnMessage,
                    message: message,
                    sender: widget.chat.members
                        .where((e) => e.uid == message.senderID)
                        .first);
              }),
        );
      } else {
        return const Align(
          alignment: Alignment.center,
          child: Text(
            'Be the First one to say Hii',
            style: TextStyle(color: AppColor.kTextWhiteColor),
          ),
        );
      }
    } else {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColor.kWhite,
        ),
      );
    }
  }
}