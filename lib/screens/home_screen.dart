import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recycle/utils/app_state.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  // title parameter is not necessary here, its just for testing.
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();

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
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: SizedBox(
                      width: 245,
                      child: TabBar(
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
                Center(
                  child: Text('Home Page'),
                ),
                Center(
                  child: Text('Community Page'),
                ),
                Center(
                  child: Text('Learn Page'),
                ),
              ],
            ),
          )),
    );
  }
}
