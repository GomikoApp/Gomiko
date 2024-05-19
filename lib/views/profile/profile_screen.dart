import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

// Auth
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Utils
import 'package:recycle/utils/providers/user_data_provider.dart';

// Views
import 'package:recycle/views/profile/edit_profile_screen.dart';

// Widgets
import 'widgets/profile_widget.dart';

// Constants
import 'package:recycle/constants.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ProfilePageState();
}

class ProfilePageState extends ConsumerState<ProfilePage> {
  bool dark = false;
  @override
  Widget build(BuildContext context) {
    // Automatically refresh the data whenever this widget is built
    ref.read(userDataNotifier.notifier).refreshData();
    final profileData = ref.watch(userDataNotifier);

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
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
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

            // User Profile Row
            Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
              child: Container(
                height: windowHeight * 0.1,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(profileData
                              .profilePictureUrl ??
                          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                    ),
                    title: Text(profileData.profileUsername ?? "J. Doe"),
                    subtitle: const Text("johndoe@gmail.com"),
                    trailing: IconButton(
                      color: primaryGreen,
                      icon: const Icon(Iconsax.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const EditProfile(title: "Edit Profile"),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // Stats Section
            const Padding(
              padding: EdgeInsets.only(left: 20.0, bottom: 5.0),
              child: Text("My Stats",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
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
                              color: primaryGreen,
                            ),
                            SizedBox(width: windowWidth * 0.02),
                            // NOTE: might be wrong
                            Text(profileData.points.toString()),
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
                              color: primaryGreen,
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
                              color: primaryGreen,
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

            // Collections Section
            const Padding(
              padding: EdgeInsets.only(left: 20.0, bottom: 5.0),
              child: Text(
                "Collections",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                bottom: 10.0,
              ),
              child: Column(
                children: <Widget>[
                  // Liked Posts
                  CustomInkWell(
                    topRight: true,
                    topLeft: true,
                    // TODO: implement liked posts
                    onTap: () {
                      if (kDebugMode) print("Liked Posts");
                    },
                    leading: const Icon(Iconsax.camera),
                    title: const Text("Liked Posts"),
                    trailing: const Icon(Iconsax.arrow_right_3),
                  ),

                  Container(
                    height: 2,
                    color: Colors.grey[300],
                  ),

                  // Saved Posts
                  CustomInkWell(
                    bottomRight: true,
                    bottomLeft: true,
                    // TODO: implement saved posts
                    onTap: () {
                      if (kDebugMode) print("Saved Posts");
                    },
                    leading: const Icon(Iconsax.archive_1),
                    title: const Text("Saved Posts"),
                    trailing: const Icon(Iconsax.arrow_right_3),
                  ),
                ],
              ),
            ),

            // Settings Section
            const Padding(
              padding: EdgeInsets.only(left: 20.0, bottom: 5.0),
              child: Text("Settings",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                bottom: 10.0,
              ),
              child: Column(
                children: <Widget>[
                  // Appearance
                  CustomInkWell(
                    topRight: true,
                    topLeft: true,
                    // TODO: implement appearance
                    onTap: () {
                      if (kDebugMode) print("Appearance");
                    },
                    leading: const Icon(Iconsax.moon),
                    title: const Text("Appearance"),
                    trailing: const Icon(Iconsax.arrow_right_3),
                  ),

                  Container(
                    height: 2,
                    color: Colors.grey[300],
                  ),

                  // Login and Security
                  CustomInkWell(
                    // TODO: implement login and security
                    onTap: () {
                      if (kDebugMode) print("Login and Security");
                    },
                    leading: const Icon(Iconsax.lock),
                    title: const Text("Login and Security"),
                    trailing: const Icon(Iconsax.arrow_right_3),
                  ),

                  Container(
                    height: 2,
                    color: Colors.grey[300],
                  ),

                  // Privacy
                  CustomInkWell(
                    // TODO: implement privacy
                    onTap: () {
                      if (kDebugMode) print("Privacy");
                    },
                    leading: const Icon(Iconsax.information),
                    title: const Text("Privacy"),
                    trailing: const Icon(Iconsax.arrow_right_3),
                  ),

                  Container(
                    height: 2,
                    color: Colors.grey[300],
                  ),

                  // Sign Out
                  CustomInkWell(
                    bottomLeft: true,
                    bottomRight: true,
                    onTap: () {
                      if (kDebugMode) print("Sign Out");
                      signOut();
                    },
                    leading: const Icon(Iconsax.logout),
                    title: const Text(
                      "Log Out",
                      style: TextStyle(color: primaryRed),
                    ),
                    trailing: const Icon(Iconsax.arrow_right_3),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
