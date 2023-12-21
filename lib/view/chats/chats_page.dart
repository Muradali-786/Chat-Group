import 'package:chat_group/utils/component/custom_list_tile.dart';
import 'package:chat_group/utils/component/top_bar.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    _authenticationProvider = Provider.of<AuthenticationProvider>(context);
    return Scaffold(
      body: _builtUi(),
    );
  }

  Widget _builtUi() {
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
    return _chatTile();
  }

  Widget _chatTile() {
    return CustomListViewTileWithActivity(
        height: deviceHeight * 0.10,
        title: 'Murad Ali Khan',
        subtitle: 'Message ',
        imagePath: 'https://i.pravatar.cc/1000?img=65',
        isActive: true,
        isActivity: true,
        onTap: () {});
  }
}
