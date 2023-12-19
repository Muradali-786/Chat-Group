import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  final double preferredHeight;
  final TextStyle? textStyle;
  final bool automaticallyImplyLeading;
  final bool showIcon; // Add this variable to control icon visibility
  final Image? leadingImage; // Add this variable for the leading icon

  const CustomAppBar({
    Key? key,
    required this.titleText,
    required this.preferredHeight,
    this.textStyle,
    this.automaticallyImplyLeading = false,
    this.showIcon = false, // Initialize the variable with false
    this.leadingImage, // Initialize the leading image as null
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(preferredHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: automaticallyImplyLeading,
      flexibleSpace: PreferredSize(
        preferredSize: Size.fromHeight(preferredHeight),
        child: Center(
          child: Text(
            titleText,
          ),
        ),
      ),
      leading: leadingImage != null
          ? InkWell(
              onTap: () {}, // Call the callback on tap
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: leadingImage,
              ),
            )
          : null,
    );
  }
}
