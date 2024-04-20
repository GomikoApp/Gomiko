import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/leaderboard_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';

class HomeScaffold extends StatefulWidget {
  const HomeScaffold({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyHomeScaffoldState();
}

class _MyHomeScaffoldState extends State<HomeScaffold> {
  int _selectedIndex = 0;

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _destinations = const <NavigationDestination>[
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      label: '',
    ),
    NavigationDestination(
      icon: Icon(Icons.search),
      label: '',
    ),
    //Scuffed way to fix the floating action button position
    NavigationDestination(
      icon: Icon(Icons.add, size: 0),
      label: '',
      tooltip: null,
      enabled: false,
    ),
    NavigationDestination(
      icon: Icon(Icons.leaderboard),
      label: '',
    ),
    NavigationDestination(
      icon: Icon(Icons.person),
      label: '',
    ),
  ];

  final List<Widget> _pages = const <Widget>[
    HomePage(title: 'Home'),
    SearchPage(title: 'Search'),
    HomePage(title: 'Don\'t touch me :)'),
    LeaderboardPage(title: 'Leaderboard'),
    ProfilePage(title: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gomiko'),
        ),
        body: Center(
          child: _pages.elementAt(_selectedIndex),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SizedBox(
          height: 70,
          width: 70,
          child: FloatingActionButton(
            //TODO: Add functionality to scan button
            onPressed: () {},
            tooltip: 'Scan',
            shape: const CircleBorder(),
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.camera_alt,
              size: 40,
            ),
          ),
        ),
        bottomNavigationBar: NavigationBar(
          height: 60,
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onDestinationSelected,
          destinations: _destinations,
          indicatorColor: const Color(0xFF95CA4A),
          surfaceTintColor: Colors.white,
        ),
      ),
    );
  }
}
