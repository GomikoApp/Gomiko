import 'package:flutter/material.dart';

class LeaderboardPage extends StatefulWidget {
  // title parameter is not necessary here, its just for testing.
  const LeaderboardPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => LeaderboardPageState();
}

class LeaderboardPageState extends State<LeaderboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Hello, world! I'm ${widget.title}."),
      ),
    );
  }
}
