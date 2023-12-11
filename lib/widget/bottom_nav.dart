import 'package:flutter/material.dart';

class NavigationBarApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
        onDestinationSelected: (int index) {
          // Handle the selected index if needed
          // You can perform some action here or navigate to a different page
          // NavigationDestinationLabelBehavior.onlyShowSelected;
        },
        indicatorColor: Colors.amber,
        destinations: const <Widget>[
          NavigationDestination(
            // selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.notifications_sharp),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_sharp),
            label: 'Notifications',
          ),
          NavigationDestination(
            icon: Icon(Icons.messenger_sharp),
            label: 'Messages',
          ),
        ],
    );
  }
}
