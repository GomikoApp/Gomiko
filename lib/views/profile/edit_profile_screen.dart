import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recycle/utils/providers/user_data_provider.dart';

// widgets
import 'widgets/build_edit_name.dart';
import 'widgets/build_edit_profile_picture.dart';
import 'widgets/build_edit_username.dart';
import 'widgets/build_edit_bio.dart';
import 'widgets/build_edit_location.dart';

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

    final userData = ref.watch(userDataProvider);

    return Scaffold(
      backgroundColor: backgroundPrimary,
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
          Column(
            children: <Widget>[
              // Name
              BuildEditNameField(
                windowWidth: windowWidth,
                userData: userData,
              ),
              // Divider
              Container(height: 1, color: Colors.grey[300]),
              // Username
              BuildEditUsernameField(
                windowWidth: windowWidth,
                userData: userData,
              ),
              // Divider
              Container(height: 1, color: Colors.grey[300]),
              // Location
              BuildEditLocationField(
                windowWidth: windowWidth,
                userData: userData,
              ),
              // Divider
              Container(height: 1, color: Colors.grey[300]),
              // Bio
              BuildEditBioField(
                windowWidth: windowWidth,
                userData: userData,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
