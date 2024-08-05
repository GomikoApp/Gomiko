import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recycle/constants.dart';
import 'package:recycle/utils/data_classes.dart';
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
                            fontSize: 28, fontWeight: FontWeight.bold),
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
                        height: 50,
                        width: double.infinity,
                        child: DropdownButton<String>(
                          value: userRegion,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          iconSize: 24,
                          style: const TextStyle(color: Colors.black),
                          onChanged: (String? newValue) {
                            // TODO: Update userRegion o nFirebase
                            setState(() {
                              userPrefecture = null;
                              userRegion = newValue!;
                            });
                          },
                          items: <String>[
                            'Hokkaido',
                            'Tohoku',
                            'Kanto',
                            'Chubu',
                            'Kansai',
                            'Chugoku',
                            'Shikoku',
                            'Kyushu',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
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
                        height: 50,
                        width: double.infinity,
                        child: DropdownButton<String>(
                            value: userPrefecture,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            iconSize: 24,
                            style: const TextStyle(color: Colors.black),
                            onChanged: (String? newValue) {
                              setState(() {
                                userPrefecture = newValue!;
                              });
                            },
                            items: regionPrefectures[userRegion]!
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList()),
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
