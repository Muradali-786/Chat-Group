import 'package:chat_group/constant/app_style/app_color.dart';
import 'package:chat_group/utils/component/top_bar.dart';
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
  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    _authenticationProvider = Provider.of<AuthenticationProvider>(context);
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
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
                icon: Icon(
                  Icons.logout,
                  color: AppColor.kButtonColor,
                )),
          )
        ],
      ),
    );
  }
}
