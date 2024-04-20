import 'package:flutter/material.dart';
import 'package:recycle/views/home_screen.dart';

// import '../pages/home.dart';
import '../views/profile_screen.dart';
import '../views/search_screen.dart';
import '../views/leaderboard_screen.dart';

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
          height: 75,
          width: 75,
          child: FloatingActionButton(
            //TODO: Add functionality to scan button
            onPressed: () {},
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