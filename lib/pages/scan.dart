import "package:camera/camera.dart";
import "package:flutter/material.dart";

// Code from: https://docs.flutter.dev/cookbook/plugins/picture-using-camera
Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: TakePictureScreen(
        // Pass the appropriate camera to the TakePictureScreen widget
        camera: firstCamera,
      ),
    ),
  );
}