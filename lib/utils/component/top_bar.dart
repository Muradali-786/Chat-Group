import 'package:chat_group/constant/app_style/app_color.dart';
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  String _barTitle;
  Widget? primaryAction;
  Widget? secondaryAction;
  double? fontSize;

  late double _deviceHeight;
  late double _deviceWidth;

  TopBar(
      this._barTitle, {
        this.primaryAction,
        this.secondaryAction,
        this.fontSize = 35,
      });

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return _buildUI();
  }

  Widget _buildUI() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (secondaryAction != null) secondaryAction!,
        Column(
          children: [
            _titleBar(),
          ],
        ),
        if (primaryAction != null) primaryAction!,
      ],
    );
  }

  Widget _titleBar() {
    return Text(
      _barTitle,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: AppColor.kTextWhiteColor,
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
