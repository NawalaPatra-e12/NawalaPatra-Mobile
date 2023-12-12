import 'package:flutter/material.dart';
import 'package:nawalapatra_mobile/library/book_list.dart';
import 'package:nawalapatra_mobile/common/menu.dart';


class NavigationBarApp extends StatelessWidget {
  // NavigationDestinationLabelBehavior labelBehavior = NavigationDestinationLabelBehavior.onlyShowSelected;
  
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
        onDestinationSelected: (int index) {
          // Handle the selected index if needed
          switch(index) {
            case 0:
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
              break;
            case 1:
              Navigator.push(context, MaterialPageRoute(builder: (context) => BooklistPage()));
              break;
            case 2:
              // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
              break;
          }
        },
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.notifications_sharp),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            label: 'Library',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
    );
  }
}

