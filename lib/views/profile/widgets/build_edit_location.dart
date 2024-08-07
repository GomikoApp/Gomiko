import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recycle/constants.dart';
import 'package:recycle/utils/data_classes.dart';
import 'package:recycle/views/profile/widgets/profile_widget.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  @override
  Widget build(BuildContext context) {
    // User Location
    String userLocation = widget.userData[UserData.keyLocation];
    String userRegion = userLocation.split(',').first.trim();
    String? userPrefecture = userLocation.split(',').last.trim();

    Map<String, List<String>> regionPrefectures = {
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

    return CustomInkWell(
      onTap: () {
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
                    Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),

                    // Edit Location Text
                    const Padding(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 10.0),
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
                    ),

                    // Location Dropdown By Japanese Region
                    const Padding(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 10.0),
                      child: Text("Region",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                    ),

                    // Location Dropdown
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 10.0),
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
                    ),

                    // Dynamically render prefecture dropdown depending on regionDropDownValue
                    const Padding(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 10.0),
                      child: Text("Prefecture",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                    ),

                    // Prefecture Dropdown
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 10.0),
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
                    ),

                    // Save Button
                    Padding(
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
                            // TODO: Update user's location in Firestore
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
                    ),
                  ],
                ),
              );
            });
          },
        );
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
