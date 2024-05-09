import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

// Auth
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Views
import 'package:recycle/views/profile/edit_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  bool dark = false;
  @override
  Widget build(BuildContext context) {
    double windowWidth = MediaQuery.of(context).size.width;
    double windowHeight = MediaQuery.of(context).size.height;

    // TODO: Design the sighout settings and call signOut() function
    Future<void> signOut() async {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      await FacebookAuth.instance.logOut();
      if (context.mounted) {
        context.pushReplacement('/login');
      }
    }

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: windowHeight * 0.05),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: windowWidth * 0.05),
              child: const Text(
                'Profile',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          SizedBox(
            height: windowHeight * 0.02,
          ),
          // User Profile Row
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: GestureDetector(
                  child: const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xff98cb51),
                    child: Icon(
                      Iconsax.user,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("John Doe",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text(
                    "johndoe@gmail.com",
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              SizedBox(
                width: windowWidth * 0.4,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const EditProfile(title: 'Edit Profile'),
                    ),
                  );
                },
                child: const Icon(
                  Iconsax.edit,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          // Stats Section
          SizedBox(height: windowHeight * 0.02),
          const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text("My Stats",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
            decoration: BoxDecoration(
              // TODO: Update background color
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Icon(
                            Iconsax.star,
                            size: 30,
                            color: Colors.black,
                          ),
                          SizedBox(width: windowWidth * 0.02),
                          const Text("1200"),
                        ],
                      ),
                      SizedBox(height: windowHeight * 0.01),
                      const Text("Total Points"),
                    ],
                  ),
                  SizedBox(width: windowWidth * 0.05),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Icon(
                            Iconsax.ranking_1,
                            size: 30,
                            color: Colors.black,
                          ),
                          SizedBox(width: windowWidth * 0.02),
                          const Text("43"),
                        ],
                      ),
                      SizedBox(height: windowHeight * 0.01),
                      const Text("Ranking"),
                    ],
                  ),
                  SizedBox(width: windowWidth * 0.05),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Icon(
                            Iconsax.layer,
                            size: 30,
                            color: Colors.black,
                          ),
                          SizedBox(width: windowWidth * 0.02),
                          const Text("83"),
                        ],
                      ),
                      SizedBox(height: windowHeight * 0.01),
                      const Text("Photos Taken"),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Theme Settings
          SizedBox(height: windowHeight * 0.01),
          const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text("Theme",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: ListTile(
              leading: const Icon(Iconsax.moon),
              title: const Text("Dark Mode"),
              trailing: Switch(
                value: dark,
                activeColor: const Color(0xff98cb51),
                onChanged: (value) {
                  setState(() {
                    dark = value;
                  });
                },
              ),
            ),
          ),
          // Settings Section
          const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text("Settings",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Column(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Iconsax.heart),
                    trailing: const Icon(Iconsax.arrow_right_3),
                    title: const Text("Liked Posts"),
                    onTap: () {}),
                const Divider(
                  height: 12,
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                ),
                ListTile(
                    leading: const Icon(Iconsax.archive_1),
                    trailing: const Icon(Iconsax.arrow_right_3),
                    title: const Text("Saved Items"),
                    onTap: () {}),
                const Divider(
                  height: 12,
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                ),
                ListTile(
                  leading: const Icon(Iconsax.lock),
                  title: const Text("Privacy"),
                  trailing: const Icon(Iconsax.arrow_right_3),
                  onTap: () {},
                ),
                const Divider(
                  height: 12,
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                ),
                ListTile(
                  leading: const Icon(Iconsax.logout),
                  title: const Text("Log Out",
                      style: TextStyle(color: Colors.red)),
                  onTap: signOut,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
