import 'package:flutter/material.dart';
import 'package:nawalapatra_mobile/library/book_list.dart';
import 'package:nawalapatra_mobile/profile/profile.dart';
import 'package:nawalapatra_mobile/screens/menu.dart';

int _currentIndex = 0; // Set the initial selected index here

class NavigationBarApp extends StatefulWidget {
  const NavigationBarApp({Key? key}) : super(key: key);

  @override
  _NavigationBarAppState createState() => _NavigationBarAppState();
}

class _NavigationBarAppState extends State<NavigationBarApp> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: kBottomNavigationBarHeight + 12, // Adjust height as needed
      decoration: const BoxDecoration(
        color: Color.fromARGB(
            255, 6, 22, 38), // Background color of the navigation bar
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                _onDestinationSelected(0);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.home,
                    color: _currentIndex == 0
                        ? Colors.white
                        : const Color.fromARGB(255, 97, 193, 181),
                  ),
                  Text(
                    "Home",
                    style: TextStyle(
                      color: _currentIndex == 0
                          ? Colors.white
                          : const Color.fromARGB(255, 97, 193, 181),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                _onDestinationSelected(1);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.library_books,
                    color: _currentIndex == 1
                        ? Colors.white
                        : const Color.fromARGB(255, 97, 193, 181),
                  ),
                  Text(
                    "Library",
                    style: TextStyle(
                      color: _currentIndex == 1
                          ? Colors.white
                          : const Color.fromARGB(255, 97, 193, 181),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                _onDestinationSelected(2);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person,
                    color: _currentIndex == 2
                        ? Colors.white
                        : const Color.fromARGB(255, 97, 193, 181),
                  ),
                  Text(
                    "Profile",
                    style: TextStyle(
                      color: _currentIndex == 2
                          ? Colors.white
                          : const Color.fromARGB(255, 97, 193, 181),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onDestinationSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Perform navigation based on the selected index
    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyHomePage()));
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const BooklistPage()));
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ProfilePage()));
        break;
    }
  }
  //   return NavigationBar(
  //     backgroundColor: const Color.fromARGB(255, 6, 22, 38),
  //     selectedIndex: selectedIndex,
  //     onDestinationSelected: (int index) {
  //       // Handle the selected index if needed
  //       setState(() {
  //         selectedIndex = index;
  //       });

  //       switch (index) {
  //         case 0:
  //           Navigator.push(
  //               context, MaterialPageRoute(builder: (context) => MyHomePage()));
  //           break;
  //         case 1:
  //           Navigator.push(context,
  //               MaterialPageRoute(builder: (context) => BooklistPage()));
  //           break;
  //         case 2:
  //           Navigator.push(context,
  //               MaterialPageRoute(builder: (context) => ProfilePage()));
  //           break;
  //       }
  //     },
  //     destinations: const <Widget>[
  //       NavigationDestination(
  //         icon:
  //             Icon(Icons.home, color: const Color.fromARGB(255, 97, 193, 181)),
  //         label: 'Home',
  //         selectedIcon:
  //             Icon(Icons.home, color: const Color.fromARGB(255, 97, 193, 181)),
  //       ),
  //       NavigationDestination(
  //         icon: Icon(Icons.library_books,
  //             color: const Color.fromARGB(255, 97, 193, 181)),
  //         label: 'Library',
  //         selectedIcon: Icon(Icons.library_books,
  //             color: const Color.fromARGB(255, 97, 193, 181)),
  //       ),
  //       NavigationDestination(
  //         icon: Icon(Icons.person,
  //             color: const Color.fromARGB(255, 97, 193, 181)),
  //         label: 'Profile',
  //         selectedIcon: Icon(Icons.person,
  //             color: const Color.fromARGB(255, 97, 193, 181)),
  //       ),
  //     ],
  //   );
  // }
}
