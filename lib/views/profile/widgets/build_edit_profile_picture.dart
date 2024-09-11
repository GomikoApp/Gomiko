import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:recycle/utils/data_classes.dart';

class BuildEditProfilePicture extends StatelessWidget {
  const BuildEditProfilePicture({
    super.key,
    required this.userData,
  });

  final Map<String, dynamic> userData;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(
                    userData[UserData.keyProfilePictureUrl] ??
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
    );
  }
}
