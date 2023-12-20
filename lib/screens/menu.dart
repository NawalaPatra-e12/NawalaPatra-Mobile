import 'package:flutter/material.dart';
import 'package:nawalapatra_mobile/widgets/left_drawer.dart';
import 'package:nawalapatra_mobile/widgets/nav_card.dart';
import 'package:nawalapatra_mobile/widgets/nav_bottom.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  final List<NavItem> items = [
    NavItem("Library", Icons.checklist, const Color(0xff7f5478)),
    NavItem("Writers Jam", Icons.draw_sharp, const Color(0xff7f5478)),
    NavItem("Leaderboard", Icons.bar_chart_rounded, const Color(0xff7f5478)),
    NavItem("Logout", Icons.logout, const Color(0xff7f5478)),
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
      appBar: AppBar(
        title: const Text(
          'NawalaPatra',
        ),
        backgroundColor: const Color(0xff3e2f48), //added colour for appbar!
        foregroundColor: Colors.white,
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
                  'Captchalogue Deck', // Text yang menandakan toko
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBarApp(),
    );
  }
}