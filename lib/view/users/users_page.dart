import 'package:chat_group/constant/app_style/app_color.dart';
import 'package:chat_group/model/chat_user.dart';
import 'package:chat_group/utils/component/custom_input_text_filed2.dart';
import 'package:chat_group/utils/component/custom_list_tile.dart';
import 'package:chat_group/utils/component/top_bar.dart';
import 'package:chat_group/view_model/user/user_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/auth/auth_provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late double deviceHeight;
  late double deviceWidth;
  late AuthenticationProvider _authenticationProvider;
  final TextEditingController _searController = TextEditingController();
  final searchFocus = FocusNode();

  late UserPageProvider _userPageProvider;

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    _authenticationProvider = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserPageProvider>(
          create: (_) => UserPageProvider(_authenticationProvider),
        )
      ],
      child: Scaffold(
        body: _buildUI(),
      ),
    );
  }

  Widget _buildUI() {
    return Builder(builder: (BuildContext context) {
      _userPageProvider = context.watch<UserPageProvider>();
      return Container(
        height: deviceHeight * 0.98,
        width: deviceWidth * 0.97,
        padding: EdgeInsets.symmetric(
            horizontal: deviceWidth * 0.03, vertical: deviceHeight * 0.03),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopBar(
              'Users',
              primaryAction: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.logout,
                    color: AppColor.kButtonColor,
                  )),
            ),
            SizedBox(
              height: deviceHeight * 0.02,
            ),
            _searchField(),
            _usersList(),
          ],
        ),
      );
    });
  }

  Widget _searchField() {
    return SizedBox(
      height: deviceHeight * 0.09,
      child: CustomTextField(
          onEditingComplete: (v) {},
          hintText: 'Search...',
          obscureText: false,
          controller: _searController),
    );
  }

  Widget _usersList() {
    List<ChatUserModel>? _users = _userPageProvider.users;
    return Expanded(child: () {
      if (_users != null) {
        if (_users.length != 0) {
          return ListView.builder(
            itemCount: _users.length,
            itemBuilder: (BuildContext context, int index) {
              return CustomListViewTile(
                height: deviceHeight * 0.10,
                title: _users[index].name,
                subtitle: "Last Active: ${_users[index].lastDayActive()}",
                imagePath: _users[index].imageURL,
                isActive: _users[index].wasRecentlyActive(),
                isSelected:
                    _userPageProvider.selectedUser.contains(_users[index]),
                onTap: () {
                  _userPageProvider.updateSelectedUser(_users[index]);
                },
              );
            },
          );
        } else {
          return const Center(
            child: Text(
              "No Users Found.",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
        }
      } else {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      }
    }());
  }

  // Widget _createChatButton() {
  //   return Visibility(
  //     visible: _pageProvider.selectedUsers.isNotEmpty,
  //     child: RoundedButton(
  //       name: _pageProvider.selectedUsers.length == 1
  //           ? "Chat With ${_pageProvider.selectedUsers.first.name}"
  //           : "Create Group Chat",
  //       height: _deviceHeight * 0.08,
  //       width: _deviceWidth * 0.80,
  //       onPressed: () {
  //         _pageProvider.createChat();
  //       },
  //     ),
  //   );
  // }
}
