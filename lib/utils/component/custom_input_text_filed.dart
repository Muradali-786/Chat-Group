import 'package:flutter/material.dart';

import '../../constant/app_style/app_color.dart';

class CustomInputTextField extends StatelessWidget {
  final TextEditingController myController;
  final FocusNode focusNode;
  final FormFieldSetter onFieldSubmittedValue;
  final Function(String) onSaved;

  // final FormFieldValidator onValidator;
  final TextInputType keyBoardType;
  final bool obsecureText;
  final String hint, regEx;
  final Color cursorColor;
  final bool enable, autoFocus;
  IconData? icon;
  CustomInputTextField(
      {Key? key,
      this.cursorColor = AppColor.kWhite,
      required this.myController,
      required this.focusNode,
      required this.onSaved,
      required this.onFieldSubmittedValue,
      required this.hint,
      required this.regEx,
      // required this.onValidator,
      required this.keyBoardType,
      this.obsecureText = false,
      this.enable = true,
      this.autoFocus = true,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:30),
      child: TextFormField(
        controller: myController,
        focusNode: focusNode,
        onFieldSubmitted: onFieldSubmittedValue,
        validator: (val) {
          return RegExp(regEx).hasMatch(val!) ? null : 'Enter a valid Value';
        },
        keyboardType: keyBoardType,
        cursorColor: cursorColor,
        enabled: enable,
        onSaved: (value) => onSaved(value!),
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        style: const TextStyle(color: AppColor.kTextWhiteColor),
        decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white54),
            fillColor: AppColor.kThemeColor,
            filled: true,

            contentPadding: const EdgeInsets.all(15),
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColor.kThemeColor),
                borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColor.kThemeColor),
                borderRadius: BorderRadius.circular(8)),
            errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColor.kAlertColor),
                borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColor.kThemeColor),
                borderRadius: BorderRadius.circular(8))),
      ),
    );
  }
}
