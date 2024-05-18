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
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return FractionallySizedBox(
                        heightFactor: 0.7,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          left: 20.0, top: 10.0, bottom: 10.0),
                                      child: Text(
                                        "Edit Name",
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: TextField(
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        width: 2,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: primaryGreen,
                                        width: 2,
                                      ),
                                    ),
                                    labelText: "John Doe",
                                    floatingLabelStyle: const TextStyle(
                                      color: primaryGreen,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: SizedBox(
                                  height: 50,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryGreen,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "Save",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                leading: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
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

              // Username
              Container(height: 1, color: Colors.grey[300]),
              CustomInkWell(
                onTap: () {
                  if (kDebugMode) print("Username Tapped");
                },
                leading: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
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

              // Location
              Container(height: 1, color: Colors.grey[300]),
              CustomInkWell(
                onTap: () {
                  if (kDebugMode) print("Location Tapped");
                },
                leading: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
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

              // Bio
              Container(height: 1, color: Colors.grey[300]),
              CustomInkWell(
                bottomRight: true,
                bottomLeft: true,
                onTap: () {
                  if (kDebugMode) print("Bio Tapped");
                },
                leading: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
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
