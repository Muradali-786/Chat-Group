import 'package:chat_group/constant/app_style/app_color.dart';
import 'package:chat_group/view/login/login_page.dart';
import 'package:chat_group/view/splash/splash_page.dart';
import 'package:chat_group/view_model/services/navigation/navigation_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    SplashPage(
      key: UniqueKey(),
      onInitializationComplete: () {
        runApp(
          const MainApp(),
        );
      },
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Group Chat",
      debugShowCheckedModeBanner: false,
      color: AppColor.kBgColor,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColor.kScaffoldBgColor,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColor.kBgColor,
        ),
      ),
      navigatorKey: NavigationService.navigatorKey,
      initialRoute: '/login',
      routes: {

        '/login':(BuildContext context)=>const LoginPage()
      },
    );
  }
}
