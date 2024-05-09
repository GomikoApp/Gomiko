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
  @override
  Widget build(BuildContext context) {
    double windowWidth = MediaQuery.of(context).size.width;
    double windowHeight = MediaQuery.of(context).size.height;

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
        children: [
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
            children: [
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
                children: [
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
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
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
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
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
                    children: [
                      Row(
                        children: [
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
                    children: [
                      Row(
                        children: [
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
          )
        ],
      ),
    );
  }
}
