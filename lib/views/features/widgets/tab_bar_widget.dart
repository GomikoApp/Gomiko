import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recycle/views/features/community/community_screen.dart';
import 'package:recycle/views/features/learn/learn_screen.dart';

// utils
import 'package:recycle/utils/providers/login_state_provider.dart';

// views
import 'package:recycle/views/features/home/home_screen.dart';

class TabBarWidget extends ConsumerStatefulWidget {
  // title parameter is not necessary here, its just for testing.
  const TabBarWidget({super.key, required this.title});

  final String title;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => TabBarWidgetState();
}

class TabBarWidgetState extends ConsumerState<TabBarWidget> {
  @override
  Widget build(BuildContext context) {
    var appState = ref.watch(applicationStateProvider);

    // Check if user is logged in, if not, push login page to screen.
    if (!appState.loggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.replace('/login');
      });
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: SizedBox(
                    width: 250,
                    child: TabBar(
                      dividerColor: Colors.transparent,
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(
                          width: 3.0,
                          color: Color(0xff98CB51),
                        ),
                      ),
                      tabAlignment: TabAlignment.start,
                      isScrollable: true,
                      labelStyle: TextStyle(
                        fontSize: 14,
                      ),
                      tabs: [
                        Tab(
                          child: Text('Home'),
                        ),
                        Tab(
                          child: Text('Community'),
                        ),
                        Tab(
                          child: Text('Learn'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: const TabBarView(
            children: [
              HomeTab(),
              CommunityTab(),
              LearnTab(),
            ],
          ),
        ),
      ),
    );
  }
}
