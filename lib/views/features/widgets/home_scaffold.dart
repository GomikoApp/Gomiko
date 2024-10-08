import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

// views
import '../../profile/profile_screen.dart';
import '../../search_screen.dart';
import '../../leaderboard_screen.dart';

// constants
import '../../../../constants.dart';

// widgets
import 'tab_bar_widget.dart';

class HomeScaffold extends StatefulWidget {
  const HomeScaffold({super.key});

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
    TabBarWidget(title: 'Home'),
    SearchPage(title: 'Search'),
    TabBarWidget(title: 'Don\'t touch me :)'),
    LeaderboardPage(title: 'Leaderboard'),
    ProfilePage(title: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryGreen,
        unselectedItemColor: secondaryGray,
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
    );
  }
}
