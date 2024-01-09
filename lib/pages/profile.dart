import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Hello, world! I'm ${widget.title}."),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              }, 
              child: const Text("Sign Out")
            ),
          ]
        ),
      ),
    );
  }
}
