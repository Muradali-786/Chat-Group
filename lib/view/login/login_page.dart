import 'package:chat_group/constant/app_style/app_color.dart';
import 'package:chat_group/constant/app_style/app_style.dart';
import 'package:chat_group/utils/component/custom_input_text_filed.dart';
import 'package:chat_group/utils/component/custom_round_button.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../utils/utils.dart';
import '../../view_model/auth/auth_provider.dart';
import '../../view_model/services/navigation/navigation_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late AuthenticationProvider _authenticationProvider;
  late NavigationService _navigationService;

  late double deviceHeight;
  late double deviceWidth;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passController = TextEditingController();
  final _passFocus = FocusNode();


  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    _authenticationProvider = Provider.of<AuthenticationProvider>(context);
    _navigationService = GetIt.instance.get<NavigationService>();
    return Scaffold(
      body: SingleChildScrollView(
        child: _buildUi(),
      ),
    );
  }

  Widget _buildUi() {
    return Container(
      height: deviceHeight * 0.98,
      width: deviceWidth * 0.97,
      padding: EdgeInsets.symmetric(
          horizontal: deviceWidth * 0.03, vertical: deviceHeight * 0.02),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          _pageTitle(),
          SizedBox(
            height: deviceHeight * 0.04,
          ),
          _loginForm(),
          SizedBox(
            height: deviceHeight * 0.05,
          ),
          _loginButton(context),
          SizedBox(
            height: deviceHeight * 0.02,
          ),
          _registerLink(),
        ],
      ),
    );
  }

  Widget _pageTitle() {
    return Text(
      'Chat Group',
      style: AppStyle()
          .defaultStyle(40, AppColor.kTextWhiteColor, FontWeight.w600),
    );
  }

  Widget _loginForm() {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomInputTextField(
                myController: _emailController,
                focusNode: _emailFocus,
                onSaved: (val) {},
                onFieldSubmittedValue: (e) {
                  Utils.onFocusChange(context, _emailFocus, _passFocus);
                },
                hint: 'Email',
                regEx:
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                keyBoardType: TextInputType.emailAddress),
            CustomInputTextField(
                myController: _passController,
                focusNode: _passFocus,
                obsecureText: true,
                onSaved: (val) {},
                onFieldSubmittedValue: (e) {},
                hint: 'Password',
                regEx: r".{5,}",
                keyBoardType: TextInputType.visiblePassword),
          ],
        ));
  }

  Widget _loginButton(BuildContext context) {
    return CustomRoundButton(
        width: deviceWidth * 0.65,
        loading: _authenticationProvider.loading,
        title: 'Login',
        onPress: () {
          if (_formKey.currentState!.validate()) {
            _authenticationProvider
                .loginUsingEmailAndPassword(
                  _emailController.text,
                  _passController.text.toString(),
                );


        }

        },
        color: AppColor.kButtonColor);
  }

  Widget _registerLink() {
    return GestureDetector(
        onTap: () => _navigationService.navigateToRoute('/sign_up'),
        child: const Text(
          'Dont\'t have an account?',
          style: TextStyle(color: Colors.blueAccent),
        ));
  }
}
