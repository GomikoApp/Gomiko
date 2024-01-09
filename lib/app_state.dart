import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

/// This change notifier maintains a global state for the app.
/// Reference: https://docs.flutter.dev/data-and-backend/state-mgmt/simple
/// In this change notifier, put anything that you want to be accessible throughout the whole app.
/// Then, in your widgets, you can create a variable that watches the root widget's change notifier state 
/// using 'BuildContext.watch<ApplicationState>()'

// from https://firebase.google.com/codelabs/firebase-get-to-know-flutter?authuser=0#4
/// This section is responsible for notifying listeners if the authentication state changes or not.
class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  // FIREBASE AUTH VARS
  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;
  bool _guestMode = false;
  /// Denotes if the user is currently signed in using guest mode.
  /// 
  /// This value automatically updates to false if the user signs in by themselves.
  bool get guestMode => _guestMode;

  Future<void> init() async {
    // FIREBASE AUTH START
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        _guestMode = false;
      } else {
        _loggedIn = false;
        _guestMode = false;
      }
      notifyListeners();
    });
    // FIREBASE AUTH END
  }

  /// Signs in as a guest.
  /// 
  /// Always include this in anything that signs in the user as a guest.
  void guestSignIn() {
    _guestMode = true;
  }
}