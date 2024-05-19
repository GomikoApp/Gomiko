import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recycle/constants.dart';

import '../firebase_options.dart';

/// This state notifier maintains a global login state variable for our app.
/// Reference: https://riverpod.dev/docs/from_provider/provider_vs_riverpod
/// To use this provider in your widgets, create a ConsumerStatefulWidget or ConsumerStatelessWidget
/// and call ref.read() with the notifier you'd like to use.
///
/// This should probably be persistent, actually.
///
/// We have Shared Preferences for this now using Constants.keyLoggedIn
final loginStateNotifier =
    StateNotifierProvider<LoginStateNotifier, bool>((ref) {
  return LoginStateNotifier();
});

class LoginStateNotifier extends StateNotifier<bool> {
  LoginStateNotifier() : super(false) {
    init();
  }

  Future<void> init() async {
    // FIREBASE AUTH START
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    final prefs = await SharedPreferences.getInstance();

    FirebaseAuth.instance.userChanges().listen((user) async {
      if (user != null) {
        state = true;
        await prefs.setBool(Constants.keyLoggedIn, true);
      } else {
        state = false;
        await prefs.setBool(Constants.keyLoggedIn, false);
      }
    });
    // FIREBASE AUTH END
  }
}
