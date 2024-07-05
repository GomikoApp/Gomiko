import 'package:flutter/material.dart';
import 'package:recycle/utils/data_classes.dart';

import 'profile_widget.dart';
import 'package:recycle/constants.dart';

class BuildEditBioField extends StatelessWidget {
  const BuildEditBioField({
    super.key,
    required this.windowWidth,
    required this.userData,
  });

  final double windowWidth;
  final Map<String, dynamic> userData;

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      bottomRight: true,
      bottomLeft: true,
      onTap: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
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
                    const Padding(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 10.0),
                      child: Text(
                        "Edit Bio",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
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
                              color: brandGreenPrimary,
                              width: 2,
                            ),
                          ),
                          labelText: userData[UserData.keyProfileBio],
                          floatingLabelStyle: const TextStyle(
                            color: brandGreenPrimary,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: brandGreenPrimary,
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
          child: const Text("Bio",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        ),
      ),
      title: Text(
        userData[UserData.keyProfileBio],
        style: const TextStyle(fontSize: 18),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
