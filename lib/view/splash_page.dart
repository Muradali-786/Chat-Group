import 'package:chat_group/constant/app_style/app_color.dart';
import 'package:chat_group/view_model/services/navigation_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import 'package:get_it/get_it.dart';
import '../constant/image_url/image_url.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback onInitializationComplete;

  const SplashPage({
    required Key key,
    required this.onInitializationComplete,
  }) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setup().then(
      (_) => widget.onInitializationComplete(),
    );
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    double w = MediaQuery.of(context).size.height;
    return MaterialApp(
        title: 'Group Chat',
        color: AppColor.kBgColor,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColor.kScaffoldBgColor,
        ),
        home: Scaffold(
          body: SafeArea(
            child: Center(
              child: SvgPicture.asset(
                ImageConstant.appLogoWithNoBG,
                height: 300,
                width: 300,
              ),
            ),
          ),
        ));
  }

  Future<void> _setup() async {
    WidgetsFlutterBinding.ensureInitialized();
    Platform.isAndroid
        ? await Firebase.initializeApp(
            options: const FirebaseOptions(
                apiKey: "AIzaSyCCAjWdipCmz7cIxeA4uqm1BhrCvR-wg54",
                appId: "1:237570366463:android:42fbb462a801bf7d91a5ca",
                messagingSenderId: "237570366463",
                projectId: "chat-group-e0fbc",
                storageBucket: "gs://chat-group-e0fbc.appspot.com"))
        : Firebase.initializeApp();

    _registerService();
  }


  //singleton class
  void _registerService() {
    GetIt.instance.registerSingleton<NavigationServices>(
      NavigationServices(),
    );
  }
}
