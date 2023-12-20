import 'package:flutter/material.dart';
import 'package:nawalapatra_mobile/library/book_list.dart';
import 'package:nawalapatra_mobile/profile/profile.dart';
import 'package:nawalapatra_mobile/screens/menu.dart';
import 'package:nawalapatra_mobile/writersjam/writer.dart';
import 'package:nawalapatra_mobile/forum/forum.dart';
import 'package:nawalapatra_mobile/leaderboard/likes_rank.dart';
// import 'package:nawalapatra_mobile/screens/login.dart';

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
              Navigator.push(context, MaterialPageRoute(builder: (context) => StoryListPage()));
              break;
            case 3:
              Navigator.push(context, MaterialPageRoute(builder: (context) => ForumPage()));
              break;
            case 4:
              Navigator.push(context, MaterialPageRoute(builder: (context) => LeaderPage()));
              break;
            case 5:
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
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
            icon: Icon(Icons.book_outlined),
            label: 'Writers Jam',
          ),
          NavigationDestination(
            icon: Icon(Icons.forum_rounded),
            label: 'Forum',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Leaderboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      onDestinationSelected: (int index) {
        // Handle the selected index if needed
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
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.library_books),
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
