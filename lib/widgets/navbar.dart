import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: shell.currentIndex,
        unselectedItemColor: const Color(0xFFFEE4A2),
        selectedItemColor: Colors.white,
        backgroundColor: const Color(0xFF451B0A),
        onTap: (index){
          shell.goBranch(index);
        }
          ,
        showSelectedLabels: true,
        showUnselectedLabels: false,
      ),
    );
  }
}
