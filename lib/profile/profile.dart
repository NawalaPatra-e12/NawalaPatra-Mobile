// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nawalapatra_mobile/library/book_list.dart';
import 'package:nawalapatra_mobile/mybooks/bookmark_list.dart';
import 'package:nawalapatra_mobile/screens/menu.dart';
import 'package:nawalapatra_mobile/screens/register.dart';
import 'package:nawalapatra_mobile/widgets/left_drawer.dart';
import 'package:nawalapatra_mobile/widgets/nav_bottom.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:nawalapatra_mobile/screens/login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    String uname = "User";

    if (request.loggedIn) {
      uname = request.jsonData["username"];
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: const Color(0xFF011627),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 20,
                height: 60,
                color: const Color(0xFF2EC4B6),
              ),
              Container(
                width: 20,
                height: 60,
                color: const Color(0xFFE71D36),
              ),
              Container(
                width: 20,
                height: 60,
                color: const Color(0xFFFF9F1C),
              ),
              const SizedBox(width: 20), // Adjust the space between rectangles
              const Text(
                'NawalaPatra',
                style: TextStyle(
                  fontFamily: 'Kidstock',
                  color: Colors.white, // Change title text color as needed
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              if (!request.loggedIn) ...[
                const Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Color.fromARGB(255, 97, 193, 181),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text('User', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 241, 163, 65),
                    borderRadius: BorderRadius.circular(
                        15.0), // Adjust the radius to your liking
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginApp()),
                      );
                    },
                    title: const Text('Sign In'),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 241, 163, 65),
                    borderRadius: BorderRadius.circular(
                        15.0), // Adjust the radius to your liking
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterApp()),
                      );
                    },
                    title: const Text('Sign Up'),
                  ),
                ),
                const SizedBox(height: 10),
              ] else ...[
                /// -- MENU

                const Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Color.fromARGB(255, 97, 193, 181),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(uname, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 20),

                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 241, 163, 65),
                    borderRadius: BorderRadius.circular(
                        15.0), // Adjust the radius to your liking
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BooklistPage()),
                      );
                    },
                    title: const Text('Library'),
                  ),
                ),
                const SizedBox(height: 10),

                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 241, 163, 65),
                    borderRadius: BorderRadius.circular(
                        15.0), // Adjust the radius to your liking
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BookmarkPage()),
                      );
                    },
                    title: const Text('My Books'),
                  ),
                ),
                const SizedBox(height: 10),

                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 241, 163, 65),
                    borderRadius: BorderRadius.circular(
                        15.0), // Adjust the radius to your liking
                  ),
                  child: ListTile(
                    onTap: () async {
                      final response = await request.logout(
                          "https://nawalapatra.pythonanywhere.com/auth/logout/");
                      String message = response["message"];
                      if (response['status']) {
                        String uname = response["username"];
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("$message Sampai jumpa, $uname."),
                        ));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MyHomePage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("$message"),
                        ));
                      }
                    },
                    title: const Text('Logout'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBarApp(),
    );
  }
}
