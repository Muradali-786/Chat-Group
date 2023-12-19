import 'package:flutter/material.dart';

import '../../constant/app_style/app_color.dart';

class InputTextField extends StatelessWidget {

  final TextEditingController myController;
  final FocusNode focusNode;
  final FormFieldSetter onFieldSubmittedValue;

  final FormFieldValidator onValidator;
  final TextInputType keyBoardType;
  final bool obsecureText;
  final String hint;
  final Color cursorColor;
  final bool enable,autoFocus;
  const InputTextField({Key? key,
    this.cursorColor=AppColor.kBlack,
    required this.myController,
    required this.focusNode,
    required this.onFieldSubmittedValue,
    required this.hint,

    required this.onValidator,
    required this.keyBoardType,
    this.obsecureText=false,
    this.enable=true,
    this.autoFocus=true,




  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        controller: myController,
        focusNode: focusNode,
        onFieldSubmitted: onFieldSubmittedValue,
        validator: onValidator,
        keyboardType: keyBoardType,
        cursorColor: cursorColor,
        enabled: enable,
        onTapOutside: (event)=>FocusScope.of(context).unfocus(),
        style: Theme.of(context).textTheme.bodyText2!.copyWith(height: 0,fontSize: 19),
        decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.all(15),
            // hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(height: 0,color: AppColors.primaryTextTextColor.withOpacity(0.8)),
            border: OutlineInputBorder(
                // borderSide: const BorderSide(color: AppColors.textFieldDefaultFocus),
                borderRadius: BorderRadius.circular(8)
            ),
            focusedBorder: OutlineInputBorder(
                // borderSide:const  BorderSide(color: AppColors.textFieldFocusBorderColor),
                borderRadius: BorderRadius.circular(8)
            ),
            errorBorder: OutlineInputBorder(
                // borderSide: const BorderSide(color: AppColors.alertColor),
                borderRadius: BorderRadius.circular(8)
            ),
            enabledBorder: OutlineInputBorder(
                // borderSide:const  BorderSide(color: AppColors.textFieldDefaultBorderColor),
                borderRadius: BorderRadius.circular(8)
            )

        ),
      ),
    );
  }
}
