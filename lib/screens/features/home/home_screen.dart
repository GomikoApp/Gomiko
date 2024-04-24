import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recycle/views/profile_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyHomeState();
}

class _MyHomeState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          // Welcome User Row
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: <Widget>[
                const Text(
                  'Hi, ',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'User!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ProfilePage(title: 'Profile'),
                        ),
                      );
                    },
                    child: const Icon(
                      Iconsax.user,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Points Container
          Container(
            margin: const EdgeInsets.only(top: 20),
            height: 150,
            width: 400,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Keep going!",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "You are 80 points away from leveling up!",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),
                  // Add a progress bar here
                  // text to show the points progress
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "120/200",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                    ),
                  ),
                  LinearProgressIndicator(
                    value: 0.8,
                    backgroundColor: Colors.grey[300],
                    minHeight: 20,
                    borderRadius: BorderRadius.circular(10),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
