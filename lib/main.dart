import 'package:flutter/material.dart';

import 'pages/home.dart';
import 'pages/profile.dart';
import 'pages/search.dart';
import 'pages/leaderboard.dart';
import 'pages/scan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _destinations = const <NavigationDestination>[
    NavigationDestination(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.search),
      label: 'Search',
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
      label: 'Leaderboard',
    ),
    NavigationDestination(
      icon: Icon(Icons.person),
      label: 'Profile',
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
    return MaterialApp(
      title: 'Gomiko',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.blue, secondary: Colors.red),
      ),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Gomiko'),
        ),
        body: Center(
          child: _pages.elementAt(_selectedIndex),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SizedBox(
          height: 75,
          width: 75,
          child: FloatingActionButton(
            //TODO: Add functionality to scan button
            onPressed: () {
              print('Scan button pressed');
            },
            tooltip: 'Scan',
            shape: const CircleBorder(),
            child: const Icon(
              Icons.camera_alt,
              size: 40,
            ),
          ),
        ),
        bottomNavigationBar: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onDestinationSelected,
              destinations: _destinations,
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height *
                  0.03, // Adjust this to adjust the position of the text
              child: const Text(
                'Scan',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
