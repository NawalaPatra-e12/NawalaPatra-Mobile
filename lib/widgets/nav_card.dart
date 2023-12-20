// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nawalapatra_mobile/screens/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:nawalapatra_mobile/library/book_list.dart';
import 'package:nawalapatra_mobile/writersjam/writer.dart';
import 'package:nawalapatra_mobile/leaderboard/likes_rank.dart';
import 'package:nawalapatra_mobile/forum/forum.dart';

class NavItem {
  final String name;
  final IconData icon;
  final Color color;

  NavItem(this.name, this.icon, this.color);
}

class NavCard extends StatelessWidget {
  final NavItem item;

  const NavCard(this.item, {super.key}); // Constructor

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Material(
      color: item.color,
      child: InkWell(
        // Area responsive terhadap sentuhan
        onTap: () async {
          // Memunculkan SnackBar ketika diklik
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text("Kamu telah menekan tombol ${item.name}!")));

          // Navigate ke route yang sesuai (tergantung jenis tombol)
          if (item.name == "Library") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const BooklistPage()));
          } else if (item.name == "Logout") {
            final response = await request.logout(
                // DO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                "https://nawalapatra.pythonanywhere.com/auth/logout/");
            String message = response["message"];
            if (response['status']) {
              String uname = response["username"];
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("$message Sampai jumpa, $uname."),
              ));
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("$message"),
              ));
            }
          }
          if (item.name == "Writers Jam") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const StoryListPage()));
          }

          if (item.name == "Leaderboard") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LeaderPage()));
          }

          if (item.name == "Forum") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ForumPage()));
          }
        },
        child: Container(
          // Container untuk menyimpan Icon dan Text
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
