import 'package:flutter/material.dart';
import 'package:nawalapatra_mobile/widgets/left_drawer.dart';
import 'package:nawalapatra_mobile/widgets/nav_card.dart';
import 'package:nawalapatra_mobile/widgets/nav_bottom.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  final List<NavItem> items = [
    NavItem("Library", Icons.library_books, const Color.fromARGB(255, 97, 193, 181)),
    NavItem("Writers Jam", Icons.draw_sharp, const Color.fromARGB(255, 241, 163, 65)),
    NavItem("Leaderboard", Icons.bar_chart_rounded, const Color.fromARGB(255, 212, 55, 62)),
    NavItem("Forum", Icons.forum_rounded, const Color.fromARGB(255, 212, 55, 62)),
    NavItem("MyBooks", Icons.bookmark_rounded, const Color.fromARGB(255, 97, 193, 181)),
    NavItem("Logout", Icons.logout, const Color.fromARGB(255, 241, 163, 65)),
  ];
  

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  Widget build(BuildContext context) {
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
        // Widget wrapper yang dapat discroll
        child: Padding(
          padding: const EdgeInsets.all(10.0), // Set padding dari halaman
          child: Column(
            // Widget untuk menampilkan children secara vertikal
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                // Widget Text untuk menampilkan tulisan dengan alignment center dan style yang sesuai
                child: Text(
                  'Welcome to NawalaPatra!', // Text yang menandakan toko
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                // Widget Text untuk menampilkan tulisan dengan alignment center dan style yang sesuai
                child: Text(
                  'Here is a wonderland for Books lover where you can do multiple fun activities across the website', // Text yang menandakan toko
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Grid layout
              GridView.count(
                // Container pada card kita.
                primary: true,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                shrinkWrap: true,
                children: items.map((NavItem item) {
                  // Iterasi untuk setiap item
                  return NavCard(item);
                }).toList(),
              ),
              // Padding(padding: padding)
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBarApp(),
    );
  }
}
