import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// widget
import 'package:recycle/views/profile/widgets/custom_outlined_input_border.dart';
import 'package:recycle/views/profile/widgets/profile_widget.dart';

// utils
import 'package:recycle/utils/data_classes.dart';

// constants
import 'package:recycle/constants.dart';

class BuildEditUsernameField extends StatefulWidget {
  const BuildEditUsernameField({
    super.key,
    required this.windowWidth,
    required this.userData,
    required this.windowHeight,
  });

  final double windowWidth;
  final double windowHeight;
  final Map<String, dynamic> userData;

  @override
  State<BuildEditUsernameField> createState() => _BuildEditUsernameFieldState();
}

class _BuildEditUsernameFieldState extends State<BuildEditUsernameField> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController usernameController;

  @override
  void initState() {
    super.initState();
    _initializeUsernameController();
  }

  void _initializeUsernameController() {
    String username = widget.userData[UserData.keyProfileUsername];
    usernameController = TextEditingController(text: username);
  }

  void _showEditUsernameModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
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
                _buildCloseButton(context),
                _buildTitle(),
                _buildUsernameField(),
                _buildSaveButton(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 3.0),
      child: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
      child: Text(
        "Edit Username",
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

  // Username Field
  Widget _buildUsernameField() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: TextFormField(
          controller: usernameController,
          decoration: InputDecoration(
            labelText: "Username",
            labelStyle: TextStyle(color: Colors.grey[600]),
            enabledBorder: CustomOutlinedInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                width: 1.0,
              ),
            ),
            focusedBorder: CustomOutlinedInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                width: 1.0,
              ),
            ),
            border: CustomOutlinedInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: const EdgeInsets.all(10.0),
            floatingLabelStyle: const TextStyle(
              color: Colors.black,
            ),
          ),
          // TODO:: also validate if username is already taken
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your username';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
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
              //_updateUsername();
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
      onTap: () {
        _showEditUsernameModal(context);
      },
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: SizedBox(
          width: widget.windowWidth * 0.25,
          child: const Text("Username",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        ),
      ),
      title: Text(
        widget.userData[UserData.keyProfileUsername],
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
