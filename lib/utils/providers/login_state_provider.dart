import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:flutter/material.dart';

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

  bool _loading = true;
  bool get loading => _loading;

  Future<void> init() async {
    // FIREBASE AUTH START

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _loggedIn = user != null;
      _loading = false;
      notifyListeners();
    });
  }
}

// Provider for application state
final applicationStateProvider =
    ChangeNotifierProvider<ApplicationState>((ref) {
  return ApplicationState();
});
