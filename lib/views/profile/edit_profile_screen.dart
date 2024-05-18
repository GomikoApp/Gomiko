import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
    );
  }
}
