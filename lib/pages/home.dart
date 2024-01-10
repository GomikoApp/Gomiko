import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recycle/app_state.dart';
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
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          context.replace('/login');
        }
      );
    }

    return Scaffold(
      body: Center(
        child: Text("Hello, world! I'm ${widget.title}."),
      ),
    );
  }
}
