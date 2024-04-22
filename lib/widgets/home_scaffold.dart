import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';

import '../views/home_screen.dart';
import '../views/profile_screen.dart';
import '../views/search_screen.dart';
import '../views/leaderboard_screen.dart';

import '../constants.dart';

class HomeScaffold extends StatefulWidget {
  const HomeScaffold({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyHomeScaffoldState();
}

class _MyHomeScaffoldState extends State<HomeScaffold> {
  int _selectedIndex = 0;

  void _onDestinationSelected(int index) {
    // TODO: Implement scan functionality
    if (index == 2) {
      if (kDebugMode) {
        print('Scan');
      }
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = const <Widget>[
    HomePage(title: 'Home'),
    SearchPage(title: 'Search'),
    HomePage(title: 'Don\'t touch me :)'),
    LeaderboardPage(title: 'Leaderboard'),
    ProfilePage(title: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Gomiko'),
        ),
        body: Center(
          child: _pages.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: SizedBox(
          height: 75,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: bottomNavSelectedColor,
            unselectedItemColor: bottomNavUnselectedColor,
            currentIndex: _selectedIndex,
            onTap: _onDestinationSelected,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(fontSize: 12, height: 2.5),
            unselectedLabelStyle: const TextStyle(fontSize: 12, height: 2.5),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Iconsax.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.search_favorite),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.camera),
                label: 'Scan',
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.medal),
                label: 'Leaderboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.user),
                label: 'Profile',
              ),
            ],
          ),
        ));
  }
}
