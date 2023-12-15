import 'package:flutter/material.dart';
import 'package:nawalapatra_mobile/library/book_list.dart';
import 'package:nawalapatra_mobile/mybooks/bookmark_list.dart';
import 'package:nawalapatra_mobile/screens/menu.dart';
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

    if (request.loggedIn){
      uname = request.jsonData["username"];
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              
              if (!request.loggedIn) ...[
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.indigo,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text('User', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 20),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.pink[100],
                    borderRadius: BorderRadius.circular(15.0), // Adjust the radius to your liking
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.pushReplacement(
                        context, 
                        MaterialPageRoute(builder: (context) => LoginApp()),
                      );
                    },
                    title: Text('Sign In'),
                  ),
                ),
                const SizedBox(height: 10),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.pink[100],
                    borderRadius: BorderRadius.circular(15.0), // Adjust the radius to your liking
                  ),
                  child: ListTile(
                    onTap: () {
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => register()),
                      // );
                    },
                    title: Text('Sign Up'),
                  ),
                ),
                const SizedBox(height: 10),

              ] else ...[
                /// -- MENU
                
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.indigo,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(uname, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 20),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.pink[100],
                    borderRadius: BorderRadius.circular(15.0), // Adjust the radius to your liking
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.pushReplacement(
                        context, 
                        MaterialPageRoute(builder: (context) => BooklistPage()),
                      );
                    },
                    title: Text('Library'),
                  ),
                ),
                const SizedBox(height: 10),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.pink[100],
                    borderRadius: BorderRadius.circular(15.0), // Adjust the radius to your liking
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.pushReplacement(
                        context, 
                        MaterialPageRoute(builder: (context) => BookmarkPage()),
                      );
                    },
                    title: Text('My Books'),
                  ),
                ),
                const SizedBox(height: 10),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.pink[100],
                    borderRadius: BorderRadius.circular(15.0), // Adjust the radius to your liking
                  ),
                  child: ListTile(
                    onTap: () async {
                      final response = await request.logout(
                        "https://nawalapatra.pythonanywhere.com/auth/logout/"
                      );
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
                    title: Text('Logout'),
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
