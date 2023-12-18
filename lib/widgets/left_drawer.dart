import 'package:flutter/material.dart';
import 'package:nawalapatra_mobile/screens/menu.dart';
import 'package:nawalapatra_mobile/library/book_list.dart';
import 'package:nawalapatra_mobile/writersjam/writer.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            // Bagian drawer header
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
          // DO: Bagian routing
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.library_books),
            title: const Text('Library'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BooklistPage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.draw_sharp),
            title: const Text('Writers Jam'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StoryListPage(),
                  ));
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.checklist),
          //   title: const Text('Lihat Item'),
          //   // Bagian redirection ke ItemListPage
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => const ProductPage()),
          //     );
          //   },
          // ),
          // ListTile(
          //   leading: const Icon(Icons.add_shopping_cart),
          //   title: const Text('Tambah Item'),
          //   // Bagian redirection ke ShopFormPage
          //   onTap: () {
          //     Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => const ShopFormPage(),
          //         ));
          //   },
          // ),
        ],
      ),
    );
  }
}
