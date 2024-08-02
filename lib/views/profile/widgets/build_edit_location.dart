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
  });

  final double windowWidth;
  final Map<String, dynamic> userData;

  @override
  ConsumerState<BuildEditLocationField> createState() =>
      _BuildEditLocationFieldState();
}

class _BuildEditLocationFieldState
    extends ConsumerState<BuildEditLocationField> {
  @override
  Widget build(BuildContext context) {
    String dropDownValue = 'Hokkaido';

    return CustomInkWell(
      onTap: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, setState) {
              return FractionallySizedBox(
                heightFactor: 0.9,
                child: Container(
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
                      // TODO: Refactor to use Riverpod (UI will not update without StatefulBuilder)
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 10.0),
                        child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: DropdownButton<String>(
                            value: dropDownValue,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            iconSize: 24,
                            style: const TextStyle(color: Colors.black),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropDownValue = newValue!;
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
