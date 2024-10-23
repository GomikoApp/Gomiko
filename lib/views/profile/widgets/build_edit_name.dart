import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// widget
import 'custom_outlined_input_border.dart';
import 'custom_ink_well_widget.dart';

// utils
import 'package:recycle/utils/data_classes.dart';

// constants
import 'package:recycle/constants.dart';

import 'show_modal_top_bar.dart';

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
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
  }

  // Update the user's name in the database
  Future<void> _updateName() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection("/users")
          .doc(user.uid)
          .update({
        UserData.keyName:
            "${firstNameController.text} ${lastNameController.text}",
      }).catchError((error) {
        if (kDebugMode) {
          print("Failed to update user's name: $error");
        }
      });
    }
  }

  // Show the modal to edit the user's name
  void _showEditNameModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        // reset the name when the modal is closed
        String fullName = widget.userData[UserData.keyName];
        int lastSpace = fullName.lastIndexOf(' ');
        String firstName =
            (lastSpace != -1) ? fullName.substring(0, lastSpace) : fullName;
        String lastName =
            (lastSpace != -1) ? fullName.substring(lastSpace + 1) : '';
        firstNameController.text = firstName;
        lastNameController.text = lastName;

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
                Container(
                    alignment: Alignment.center, child: showModalTopBar()),
                const SizedBox(height: 20),
                _buildTitle(),
                _buildFirstNameField(),
                const SizedBox(height: 10),
                _buildLastNameField(),
                _buildSaveButton(context),
              ],
            ),
          ),
        );
      },
    );
  }

  // Title of the modal
  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
      child: Text(
        "Edit Name",
        style: TextStyle(
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

  // First name field
  Widget _buildFirstNameField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: firstNameController,
        decoration: const InputDecoration(
          enabledBorder: CustomOutlinedInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 1.0),
          ),
          focusedBorder: CustomOutlinedInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: primaryGreen, width: 2.0),
          ),
          border: CustomOutlinedInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          contentPadding: EdgeInsets.all(10.0),
          labelText: "First Name",
          floatingLabelStyle: TextStyle(
            color: primaryGreen,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your first name';
          }
          return null;
        },
      ),
    );
  }

  // Last name field
  Widget _buildLastNameField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: lastNameController,
        decoration: const InputDecoration(
          enabledBorder: CustomOutlinedInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 1.0),
          ),
          focusedBorder: CustomOutlinedInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: primaryGreen, width: 2.0),
          ),
          border: CustomOutlinedInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          contentPadding: EdgeInsets.all(10.0),
          labelText: "Last Name",
          floatingLabelStyle: TextStyle(
            color: primaryGreen,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your last name';
          }
          return null;
        },
      ),
    );
  }

  // Save button to save the user's name
  Widget _buildSaveButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
            if (_formKey.currentState!.validate()) {
              _updateName();
              Navigator.pop(context);
            }
          },
          child: const Text(
            "Save",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      topRight: true,
      topLeft: true,
      onTap: () => _showEditNameModal(context),
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: SizedBox(
          width: widget.windowWidth * 0.25,
          child: const Text(
            "Name",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      title: Text(
        widget.userData[UserData.keyName],
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
