import 'package:chat_group/constant/app_style/app_color.dart';
import 'package:chat_group/model/chat.dart';
import 'package:chat_group/model/chat_message.dart';
import 'package:chat_group/model/chat_user.dart';
import 'package:chat_group/utils/component/custom_list_tile.dart';
import 'package:chat_group/utils/component/top_bar.dart';
import 'package:chat_group/view/chat_1v1/chat_page.dart';
import 'package:chat_group/view_model/chats/chats_page_provider.dart';
import 'package:chat_group/view_model/services/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../view_model/auth/auth_provider.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late double deviceHeight;
  late double deviceWidth;
  late AuthenticationProvider _authenticationProvider;
  late ChatsPageProvider _chatPageProvider;
  late NavigationService _navigationService;

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    _authenticationProvider = Provider.of<AuthenticationProvider>(context);
    _navigationService=GetIt.instance.get<NavigationService>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatsPageProvider>(
          create: (_) => ChatsPageProvider(_authenticationProvider),
        )
      ],
      child: _builtUi(),
    );
  }

  Widget _builtUi() {
    return Builder(
      builder: (BuildContext context) {
        _chatPageProvider = context.watch<ChatsPageProvider>();
        //triger the widget to reredner it self
        return Container(
          height: deviceHeight * 0.98,
          width: deviceWidth * 0.97,
          padding: EdgeInsets.symmetric(
              horizontal: deviceWidth * 0.03, vertical: deviceHeight * 0.03),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              _topBar(),
              _chatList(),
            ],
          ),
        );
      },
    );
  }

  Widget _topBar() {
    return TopBar(
      'Chats',
      primaryAction: IconButton(
          onPressed: () {
            _authenticationProvider.logout();
          },
          icon: const Icon(Icons.logout)),
    );
  }

  Widget _chatList() {
    List<Chat>? chats = _chatPageProvider.chats;
    return Expanded(child: () {
      if (chats != null) {
        if (chats.length != null) {
          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (BuildContext context, int index) {
              return _chatTile(chats[index]);
            },
          );
        } else {
          return const Center(
            child: Text(
              'No Chats Found',
              style: TextStyle(
                color: AppColor.kWhite,
              ),
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
    }());
  }

  Widget _chatTile(Chat chat) {
    List<ChatUserModel> _recepient = chat.recepients();
    bool isActive = _recepient.any((d) => d.wasRecentlyActive());
    String subtitleText = '';
    if (chat.messages.isNotEmpty) {
      subtitleText = chat.messages.first.type != MessageType.TEXT

          ? "Media Attachment"
          : chat.messages.first.content;
      print('dekh khan ke surtehal ha');
      print(subtitleText);
    }
    return CustomListViewTileWithActivity(
        height: deviceHeight * 0.10,
        title: chat.title(),
        subtitle: subtitleText,
        imagePath: chat.imageURL(),
        isActive: isActive,
        isActivity: chat.activity,
        onTap: () {
          _navigationService.navigateToPage(ChatPage(chat: chat));

        });
  }
}
