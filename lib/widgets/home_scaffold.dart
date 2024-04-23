import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';

import 'tabBar_widget.dart';
import '../screens/leaderboard_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';

import '../constants.dart';

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
      appBar: AppBar(
        title: const Text('Gomiko'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Transform.translate(
        offset: const Offset(0, -24),
        child: SafeArea(
          child: Container(
            padding:
                const EdgeInsets.only(left: 12, top: 5, right: 12, bottom: 5),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: bottomNavBgColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: bottomNavBgColor.withOpacity(0.3),
                  offset: const Offset(0, 20),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    _onDestinationSelected(0);
                  },
                  icon: Icon(
                    Iconsax.home,
                    color: _selectedIndex == 0
                        ? bottomNavSelectedColor
                        : const Color(0xFF6E7191),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _onDestinationSelected(1);
                  },
                  icon: Icon(
                    Iconsax.search_normal,
                    color: _selectedIndex == 1
                        ? bottomNavSelectedColor
                        : bottomNavUnselectedColor,
                  ),
                ),
                IconButton(
                  // TODO: Scan functionality
                  onPressed: () {},
                  icon: const Icon(
                    Iconsax.camera,
                    color: bottomNavSelectedColor,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _onDestinationSelected(3);
                  },
                  icon: Icon(
                    Iconsax.award,
                    color: _selectedIndex == 3
                        ? bottomNavSelectedColor
                        : bottomNavUnselectedColor,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _onDestinationSelected(4);
                  },
                  icon: Icon(
                    Iconsax.user,
                    color: _selectedIndex == 4
                        ? bottomNavSelectedColor
                        : bottomNavUnselectedColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
