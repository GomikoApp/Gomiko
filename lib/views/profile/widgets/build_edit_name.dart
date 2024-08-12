import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:recycle/constants.dart';
import 'package:recycle/views/auth/widgets/error_text.dart';

// widgets
import 'custom_outlined_input_border.dart';
import 'profile_widget.dart';

// Utils
import 'package:recycle/utils/data_classes.dart';

class BuildEditNameField extends StatefulWidget {
  const BuildEditNameField({
    super.key,
    required this.windowWidth,
    required this.userData,
    required this.windowHeight,
  });

  final double windowWidth;
  final double windowHeight;
  final Map<String, dynamic> userData;

  @override
  State<BuildEditNameField> createState() => _BuildEditNameFieldState();
}

class _BuildEditNameFieldState extends State<BuildEditNameField> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String fullName = widget.userData[UserData.keyName];
    int lastSpace = fullName.lastIndexOf(' ');

    String firstName =
        (lastSpace != -1) ? fullName.substring(0, lastSpace) : fullName;
    String lastName =
        (lastSpace != -1) ? fullName.substring(lastSpace + 1) : '';

    final firstNameController = TextEditingController(text: firstName);
    final lastNameController = TextEditingController(text: lastName);

    Future<void> updateName() async {
      // get the current user
      final User? user = FirebaseAuth.instance.currentUser;

      // update the user's name
      await FirebaseFirestore.instance
          .collection("/users")
          .doc(user!.uid)
          .update({
        UserData.keyName:
            "${firstNameController.text} ${lastNameController.text}",
      }).catchError((error) {
        if (kDebugMode) {
          print("Failed to update user's name: $error");
        }
      });
    }

    return CustomInkWell(
      topRight: true,
      topLeft: true,
      onTap: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: widget.windowHeight * 0.85,
              decoration: const BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Form(
                key: _formKey,
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
                        "Edit Name",
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

                    // first name
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          controller: firstNameController,
                          decoration: InputDecoration(
                            labelText: "First Name",
                            labelStyle: TextStyle(color: Colors.grey[600]),
                            enabledBorder: const CustomOutlinedInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: const CustomOutlinedInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                width: 1.0,
                              ),
                            ),
                            border: const CustomOutlinedInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(10.0),
                            floatingLabelStyle: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // last name
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          controller: lastNameController,
                          decoration: InputDecoration(
                            labelText: "Last Name",
                            labelStyle: TextStyle(color: Colors.grey[600]),
                            enabledBorder: const CustomOutlinedInputBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: const CustomOutlinedInputBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                width: 1.0,
                              ),
                            ),
                            border: const CustomOutlinedInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(10.0),
                            floatingLabelStyle: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 20.0, bottom: 10.0),
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
                            updateName();
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
          width: widget.windowWidth * 0.25,
          child: const Text("Name",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        ),
      ),
      title: Text(
        widget.userData[UserData.keyName],
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
