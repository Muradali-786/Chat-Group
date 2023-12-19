import 'package:chat_group/constant/app_style/app_style.dart';
import 'package:flutter/material.dart';

import '../../constant/app_style/app_color.dart';

class CustomRoundButton extends StatelessWidget {
  final title;
  final VoidCallback onPress;
  final Color color, textColor;
  final bool loading;
  final double height,width;
  const CustomRoundButton(
      {Key? key,
      required this.title,
      required this.onPress,
      required this.color,
      this.textColor = Colors.white,
      this.loading = false,
      this.height=50,
        this.width=double.infinity

      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading ? null : onPress,
      child: Container(
        height:height,
        width: width,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(40)),
        child: loading
            ? const Center(
                child: CircularProgressIndicator(
                color: AppColor.kWhite,
              ))
            : Center(
                child: Text(
                title,
                style:AppStyle().defaultStyle(22, textColor, FontWeight.normal),
              )),
      ),
    );
  }
}
