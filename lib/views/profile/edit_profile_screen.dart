import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// widgets
import 'widgets/profile_widget.dart';

// constants
import '../../constants.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    double windowWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        if (kDebugMode) print("Profile Picture Tapped");
                      },
                      child: const CircleAvatar(
                        radius: 70,
                        backgroundImage: NetworkImage(
                          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (kDebugMode) print("Change Profile Picture Tapped");
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text(
                          "Change Profile Picture",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Name Field
          Column(
            children: <Widget>[
              CustomInkWell(
                topRight: true,
                topLeft: true,
                onTap: () {
                  if (kDebugMode) print("Name Tapped");
                },
                leading: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: SizedBox(
                    width: windowWidth * 0.25,
                    child: const Text("Name",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                  ),
                ),
                title: const Text(
                  "John Doe",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Container(height: 1, color: Colors.grey[300]),
              CustomInkWell(
                onTap: () {
                  if (kDebugMode) print("Username Tapped");
                },
                leading: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: SizedBox(
                    width: windowWidth * 0.25,
                    child: const Text("Username",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                  ),
                ),
                title: const Text(
                  "jDoe1",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Container(height: 1, color: Colors.grey[300]),
              CustomInkWell(
                onTap: () {
                  if (kDebugMode) print("Location Tapped");
                },
                leading: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: SizedBox(
                    width: windowWidth * 0.25,
                    child: const Text("Location",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                  ),
                ),
                title: const Text(
                  "Japan, Tokyo",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Container(height: 1, color: Colors.grey[300]),
              CustomInkWell(
                bottomRight: true,
                bottomLeft: true,
                onTap: () {
                  if (kDebugMode) print("Bio Tapped");
                },
                leading: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: SizedBox(
                    width: windowWidth * 0.25,
                    child: const Text("Bio",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                  ),
                ),
                title: const Text(
                  "Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.",
                  style: TextStyle(fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
