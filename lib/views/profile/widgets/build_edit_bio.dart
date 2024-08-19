import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:recycle/utils/data_classes.dart';
import 'package:recycle/views/profile/widgets/custom_outlined_input_border.dart';

import 'profile_widget.dart';
import 'package:recycle/constants.dart';

class BuildEditBioField extends StatefulWidget {
  const BuildEditBioField({
    super.key,
    required this.windowWidth,
    required this.userData,
    required this.windowHeight,
  });

  final double windowWidth;
  final double windowHeight;
  final Map<String, dynamic> userData;

  @override
  State<BuildEditBioField> createState() => _BuildEditBioFieldState();
}

class _BuildEditBioFieldState extends State<BuildEditBioField> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController bioController;

  @override
  void initState() {
    super.initState();
    bioController = TextEditingController();
  }

  Future<void> updateBio() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection("/users")
          .doc(user.uid)
          .update({
        UserData.keyProfileBio: bioController.text,
      }).catchError((error) {
        if (kDebugMode) {
          print("Failed to update user's bio: $error");
        }
      });
    }
  }

  void _showEditBioModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        bioController.text = widget.userData[UserData.keyProfileBio];
        return Container(
          height: widget.windowHeight * 0.85,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                _buildTitle(),
                _buildBioField(),
                _buildSaveButton(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
      child: Text(
        "Edit Bio",
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

  Widget _buildBioField() {
    return Padding(
      padding: const EdgeInsets.only(
          left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
      child: TextFormField(
        maxLines: 5,
        controller: bioController,
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
          floatingLabelStyle: TextStyle(
            color: primaryGreen,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter a bio.";
          }
          return null;
        },
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
            if (_formKey.currentState!.validate()) {
              updateBio();
              Navigator.pop(context);
            }
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
      bottomRight: true,
      bottomLeft: true,
      onTap: () {
        _showEditBioModal(context);
      },
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: SizedBox(
          width: widget.windowWidth * 0.25,
          child: const Text("Bio",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        ),
      ),
      title: Text(
        widget.userData[UserData.keyProfileBio],
        style: const TextStyle(fontSize: 18),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
