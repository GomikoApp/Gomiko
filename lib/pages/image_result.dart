import 'dart:io';

import 'package:flutter/material.dart';

class ImageResultPage extends StatelessWidget {
  final String imagePath;

  const ImageResultPage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Result')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
