import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

// firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// constants
import 'package:recycle/constants.dart';

// utils
import 'package:recycle/utils/data_classes.dart';

// widgets
import 'package:recycle/views/profile/widgets/profile_widget.dart';

class BuildEditLocationField extends ConsumerStatefulWidget {
  const BuildEditLocationField({
    super.key,
    required this.windowWidth,
    required this.userData,
    required this.windowHeight,
  });

  final double windowWidth;
  final double windowHeight;
  final Map<String, dynamic> userData;

  @override
  ConsumerState<BuildEditLocationField> createState() =>
      _BuildEditLocationFieldState();
}

class _BuildEditLocationFieldState
    extends ConsumerState<BuildEditLocationField> {
  late String userLocation;
  late String userRegion;
  late String userPrefecture;
  late Map<String, List<String>> regionPrefectures;

  @override
  void initState() {
    super.initState();
    userLocation = widget.userData[UserData.keyLocation];
    userRegion = userLocation.split(',').first.trim();
    userPrefecture = userLocation.split(',').last.trim();
    regionPrefectures = {
      'Hokkaido': [
        'Hokkaido',
      ],
      'Tohoku': [
        'Aomori',
        'Iwate',
        'Miyagi',
        'Akita',
        'Yamagata',
        'Fukushima',
      ],
      'Kanto': [
        'Tokyo',
        'Ibaraki',
        'Tochigi',
        'Gunma',
        'Saitama',
        'Chiba',
        'Kanagawa',
      ],
      'Chubu': [
        'Niigata',
        'Toyama',
        'Ishikawa',
        'Fukui',
        'Yamanashi',
        'Nagano',
        'Gifu',
        'Shizuoka',
        'Aichi',
      ],
      'Kansai': [
        'Mie',
        'Shiga',
        'Kyoto',
        'Osaka',
        'Hyogo',
        'Nara',
        'Wakayama',
      ],
      'Chugoku': [
        'Tottori',
        'Shimane',
        'Okayama',
        'Hiroshima',
        'Yamaguchi',
      ],
      'Shikoku': [
        'Tokushima',
        'Kagawa',
        'Ehime',
        'Kochi',
      ],
      'Kyushu': [
        'Fukuoka',
        'Saga',
        'Nagasaki',
        'Kumamoto',
        'Oita',
        'Miyazaki',
        'Kagoshima',
        'Okinawa',
      ],
    };
  }

  Future<void> updateUserData() async {
    // Get the current user
    final User? user = FirebaseAuth.instance.currentUser;

    // Update the user's location in Firestore
    await FirebaseFirestore.instance
        .collection("/users")
        .doc(user!.uid)
        .update({
      UserData.keyLocation: "$userRegion, $userPrefecture"
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to update user's location: $error");
      }
    });
  }

  void _showEditLocationModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            height: widget.windowHeight * 0.85,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                _buildTitle(),
                _buildRegionHeading(),
                _buildLocationDropdown(),

                // Dynamically render prefecture dropdown depending on regionDropDownValue
                _buildPrefectureHeading(),
                _buildPrefectureDropdown(),

                _buildSaveButton(context),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildTitle() {
    // Edit Location Text
    return const Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
      child: Text(
        "Edit Location",
        style: TextStyle(
          // https://github.com/flutter/flutter/issues/30541
          // add space between text and underline
          shadows: [
            Shadow(
              color: Colors.black,
              offset: Offset(0, -5),
            )
          ],
          color: Colors.transparent,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
          decorationColor: primaryGreen,
          decorationThickness: 3,
        ),
      ),
    );
  }

  Widget _buildRegionHeading() {
    // Location Dropdown By Japanese Region
    return const Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
      child: Text("Region",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildLocationDropdown() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
      child: SizedBox(
        width: double.infinity,
        child: CustomDropdown<String>(
          initialItem: userRegion,
          items: regionPrefectures.keys.toList(),
          decoration: CustomDropdownDecoration(
            closedBorderRadius: BorderRadius.circular(10),
            closedBorder: Border.all(color: Colors.black),
            expandedBorderRadius: BorderRadius.circular(10),
            expandedBorder: Border.all(color: Colors.black),
          ),
          onChanged: (String? newValue) {
            setState(() {
              userRegion = newValue!;
              userPrefecture = regionPrefectures[userRegion]!
                  .first; // Reset Prefecture to first in list
            });
          },
        ),
      ),
    );
  }

  Widget _buildPrefectureHeading() {
    return const Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
      child: Text("Prefecture",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildPrefectureDropdown() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
      child: SizedBox(
        width: double.infinity,
        child: CustomDropdown<String>(
          initialItem: userPrefecture,
          items: regionPrefectures[userRegion]!,
          decoration: CustomDropdownDecoration(
            closedBorderRadius: BorderRadius.circular(10),
            closedBorder: Border.all(color: Colors.black),
            expandedBorderRadius: BorderRadius.circular(10),
            expandedBorder: Border.all(color: Colors.black),
          ),
          onChanged: (String? newValue) {
            setState(() {
              userPrefecture = newValue!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
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
            updateUserData();
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      onTap: () {
        _showEditLocationModal(context);
      },
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: SizedBox(
          width: widget.windowWidth * 0.25,
          child: const Text("Location",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        ),
      ),
      title: Text(
        widget.userData[UserData.keyLocation],
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
