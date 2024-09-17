import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recycle/utils/providers/user_data_provider.dart';

// widgets
import 'widgets/build_edit_name.dart';
import 'widgets/build_edit_profile_picture.dart';
import 'widgets/build_edit_username.dart';
import 'widgets/build_edit_bio.dart';
import 'widgets/build_edit_location.dart';
import 'widgets/build_delete_account.dart';

// constants
import '../../constants.dart';

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({super.key, required this.title});

  final String title;

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  @override
  Widget build(BuildContext context) {
    double windowWidth = MediaQuery.of(context).size.width;
    double windowHeight = MediaQuery.of(context).size.height;

    final userData = ref.read(userDataProvider);

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
          // Profile Picture
          BuildEditProfilePicture(userData: userData),

          // Name Field
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Column(
              children: <Widget>[
                // Name
                BuildEditNameField(
                  windowWidth: windowWidth,
                  windowHeight: windowHeight,
                  userData: userData,
                ),
                // Divider
                Container(height: 1, color: Colors.grey[300]),
                // Username
                BuildEditUsernameField(
                  windowWidth: windowWidth,
                  windowHeight: windowHeight,
                  userData: userData,
                ),
                // Divider
                Container(height: 1, color: Colors.grey[300]),
                // Location
                BuildEditLocationField(
                  windowWidth: windowWidth,
                  windowHeight: windowHeight,
                  userData: userData,
                ),
                // Divider
                Container(height: 1, color: Colors.grey[300]),
                // Bio
                BuildEditBioField(
                  windowWidth: windowWidth,
                  windowHeight: windowHeight,
                  userData: userData,
                ),

                BuildDeleteAccount(
                  windowWidth: windowWidth,
                  windowHeight: windowHeight,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
