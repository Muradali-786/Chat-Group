import 'package:chat_group/constant/app_style/app_color.dart';
import 'package:chat_group/utils/component/custom_input_text_filed.dart';
import 'package:chat_group/utils/component/custom_round_button.dart';
import 'package:chat_group/utils/component/rounded_image.dart';
import 'package:chat_group/view_model/services/cloud_storage/cloud_storage_service.dart';
import 'package:chat_group/view_model/services/data_base/data_base_service.dart';
import 'package:chat_group/view_model/services/media/media_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../utils/utils.dart';
import '../../view_model/auth/auth_provider.dart';
import '../../view_model/services/navigation/navigation_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late AuthenticationProvider _authenticationProvider;
  late NavigationService _navigationService;
  late DataBaseService _db;
  late CloudStorageService _cloudStorageService;

  late double deviceHeight;
  late double deviceWidth;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nameFocus = FocusNode();
  final _emailController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passController = TextEditingController();
  final _passFocus = FocusNode();

  PlatformFile? _profileImage;

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    _authenticationProvider = Provider.of<AuthenticationProvider>(context);
    _navigationService = GetIt.instance.get<NavigationService>();
    _cloudStorageService = GetIt.instance.get<CloudStorageService>();
    _db = GetIt.instance.get<DataBaseService>();
    return Scaffold(
      body: _buildUi(),
    );
  }

  Widget _buildUi() {
    return Container(
      height: deviceHeight * 0.98,
      width: deviceWidth * 0.97,
      padding: EdgeInsets.symmetric(
          horizontal: deviceWidth * 0.03, vertical: deviceHeight * 0.02),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: deviceHeight * 0.15,
            ),
            _profileImageFiled(),
            SizedBox(
              height: deviceHeight * 0.03,
            ),
            _loginForm(),
            SizedBox(
              height: deviceHeight * 0.05,
            ),
            _signUpButton(),
            SizedBox(
              height: deviceHeight * 0.018,
            ),
            _loginPageLink(),
          ],
        ),
      ),
    );
  }

  Widget _profileImageFiled() {
    return GestureDetector(
      onTap: () {
        GetIt.instance.get<MediaService>().pickImageFromLibrary().then(
          (file) {
            setState(
              () {
                _profileImage = file;
              },
            );
          },
        );
      },
      child: () {
        if (_profileImage != null) {
          return RoundedImageFile(
            key: UniqueKey(),
            image: _profileImage!,
            size: deviceHeight * 0.15,
          );
        } else {
          return RoundedImageNetwork(
            key: UniqueKey(),
            imagePath: 'https://i.pravatar.cc/1000?img=65',
            size: deviceHeight * 0.15,
          );
        }
      }(), //anonymous funtion dont have nave
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
                myController: _nameController,
                focusNode: _nameFocus,
                onSaved: (val) {},
                onFieldSubmittedValue: (e) {
                  Utils.onFocusChange(context, _nameFocus, _emailFocus);
                },
                hint: 'Name',
                regEx: r".{5,}",
                keyBoardType: TextInputType.emailAddress),
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

  Widget _signUpButton() {
    return CustomRoundButton(
        width: deviceWidth * 0.65,
        title: 'Sign Up',
        loading: _authenticationProvider.loading,
        onPress: () async {
          if (_formKey.currentState!.validate() && _profileImage != null) {
            String? uid =
                await _authenticationProvider.signUpWithEmailAndPassword(
                    _emailController.text, _passController.text.toString());
            String? imageURL = await _cloudStorageService
                .saveUserImageToStorage(uid!, _profileImage!);

            await _db.saveUserInfoInFirebase(
              uid,
              _nameController.text,
              _emailController.text,
              imageURL!.toString(),
            );
            // await _authenticationProvider.logout();
            // await _authenticationProvider.loginUsingEmailAndPassword(
            //     _emailController.text, _passController.text.toString());
          }
        },
        color: AppColor.kButtonColor);
  }

  Widget _loginPageLink() {
    return GestureDetector(
        onTap: () => _navigationService.removeAndNavigateToRoute('/login'),
        child: const Text(
          'already have an account?',
          style: TextStyle(color: Colors.blueAccent),
        ));
  }
}
