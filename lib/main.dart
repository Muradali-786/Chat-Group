import 'package:chat_group/view/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CHAT GROUP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

       primarySwatch: Colors.blue,
           brightness: Brightness.dark
      ),
      home:const HomePage(),
    );
  }
}
