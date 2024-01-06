import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  // title parameter is not necessary here, its just for testing.
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Uncomment this code after finishing the home page.
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   var appState = Provider.of<MyAppChangeNotifier>(context, listen: false);

    //   // Check if user is logged in, if not, push login page to screen.
    //   if (!appState.loggedIn) {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => const LoginPage(title: "Login"),
    //       ),
    //     );
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // I want to add animations to these elements that is a simple fade
          // and transform up.
          const Text(
            "Welcome to Gomiko",
            textScaler: TextScaler.linear(2.5),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(title: "Login"),
                ),
              );
            },
            child: const Text("Login"),
          ),
        ],
      ),
    );
  }
}
