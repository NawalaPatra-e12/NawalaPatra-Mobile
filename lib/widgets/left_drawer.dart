import 'package:flutter/material.dart';
import 'package:nawalapatra_mobile/screens/menu.dart';
import 'package:nawalapatra_mobile/library/book_list.dart';
import 'package:nawalapatra_mobile/writersjam/writer.dart';
import 'package:nawalapatra_mobile/leaderboard/likes_rank.dart';
import 'package:nawalapatra_mobile/forum/forum.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xff3e2f48),
            ),
            child: Column(
              children: [
                Text(
                  'NawalaPatra',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  "Your trusted online library.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.library_books),
            title: const Text('Library'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BooklistPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.draw_sharp),
            title: const Text('Writers Jam'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => StoryListPage(),
                ),
              );
            },
          ),
          
            ListTile(
              leading: const Icon(Icons.draw_sharp),
              title: const Text('Forum'),
              
              onTap: () {
                if (request.loggedIn)
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ForumPage(),
                  ),
                );
              },
            ),
          ListTile(
            leading: const Icon(Icons.bar_chart_rounded),
            title: const Text('Leaderboard'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LeaderPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
