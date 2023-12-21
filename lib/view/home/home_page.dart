import 'package:chat_group/view/chats/chats_page.dart';
import 'package:chat_group/view/users/users_page.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;

  final List<Widget> _pages = const [
    ChatsPage(),
    UsersPage(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _pages[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (index) {
          setState(() {
            currentPage = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: "Chats",
            icon: Icon(Icons.chat_bubble_sharp),
          ),
          BottomNavigationBarItem(
            label: "Users",
            icon: Icon(Icons.supervised_user_circle_sharp),
          )
        ],
      ),
    );
  }

  Widget _builtUI() {
    return Column(
      children: [],
    );
  }
}
