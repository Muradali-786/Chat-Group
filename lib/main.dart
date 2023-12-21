import 'package:chat_group/constant/app_style/app_color.dart';
import 'package:chat_group/view/home/home_page.dart';
import 'package:chat_group/view/login/login_page.dart';
import 'package:chat_group/view/sign_up/sign_up_page.dart';
import 'package:chat_group/view/splash/splash_page.dart';
import 'package:chat_group/view_model/auth/auth_provider.dart';
import 'package:chat_group/view_model/services/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
            create: (BuildContext context) {
          return AuthenticationProvider();
        })
      ],
      child: MaterialApp(
        title: "Group Chat",
        debugShowCheckedModeBanner: false,
        color: AppColor.kBgColor,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColor.kScaffoldBgColor,
          primarySwatch: Colors.blue,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: AppColor.kNavBarBgColor,
            selectedIconTheme: IconThemeData(color: Colors.blue),
            selectedLabelStyle: TextStyle(color: Colors.blue),
          ),
        ),
        navigatorKey: NavigationService.navigatorKey,
        initialRoute: '/login',
        routes: {
          '/login': (BuildContext context) => const LoginPage(),
          '/sign_up': (BuildContext context) => const SignUpPage(),
          '/home': (BuildContext context) => const HomePage(),
        },
      ),
    );
  }
}
