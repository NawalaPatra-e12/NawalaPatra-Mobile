import 'package:flutter/material.dart';
import 'package:nawalapatra_mobile/library/book_list.dart';
import 'package:nawalapatra_mobile/profile/profile.dart';
import 'package:nawalapatra_mobile/screens/menu.dart';

class NavigationBarApp extends StatefulWidget {
  const NavigationBarApp({Key? key}) : super(key: key);

  @override
  _NavigationBarAppState createState() => _NavigationBarAppState();
}

class _NavigationBarAppState extends State<NavigationBarApp> {
  int selectedIndex = 0; // Set the initial selected index here

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: const Color.fromARGB(255, 6, 22, 38),
      selectedIndex: selectedIndex,
      onDestinationSelected: (int index) {
        // Handle the selected index if needed
        setState(() {
          selectedIndex = index;
        });

        switch (index) {
          case 0:
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyHomePage()));
            break;
          case 1:
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => BooklistPage()));
            break;
          case 2:
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePage()));
            break;
        }
      },
      destinations: const <Widget>[
        NavigationDestination(
          icon: Icon(Icons.home, color: const Color.fromARGB(255, 97, 193, 181)),
          label: 'Home',
          selectedIcon: Icon(Icons.home, color: const Color.fromARGB(255, 97, 193, 181)),
        ),
        NavigationDestination(
          icon: Icon(Icons.library_books, color: const Color.fromARGB(255, 97, 193, 181)),
          label: 'Library',
          selectedIcon: Icon(Icons.library_books, color: const Color.fromARGB(255, 97, 193, 181)),
        ),
        NavigationDestination(
          icon: Icon(Icons.person, color: const Color.fromARGB(255, 97, 193, 181)),
          label: 'Profile',
          selectedIcon: Icon(Icons.person, color: const Color.fromARGB(255, 97, 193, 181)),
        ),
      ],
    );
  }
}

