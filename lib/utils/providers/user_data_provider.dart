/*
  Providers from Riverpod are the way that we load and store data in RAM so that we can use it throughout the app.

  - Authored by Anthony 05/18/24
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// DATA CLASSES
import 'package:recycle/utils/data_classes.dart';
import 'package:recycle/utils/providers/login_state_provider.dart';


/// This state notifier maintains a global cache of the profile data of the currently logged in user for our app.<br>
/// Reference: https://riverpod.dev/docs/from_provider/provider_vs_riverpod 
/// 
/// To use this provider in your widgets, create a ConsumerStatefulWidget or ConsumerStatelessWidget
/// and call ref.read(userDataNotifier) if you want to get the user data, or ref.read(userDataNotifier.notifier) if you want to call its refresh function.
final userDataNotifier = 
  StateNotifierProvider<UserDataStateNotifier, UserData>((ref) {
    return UserDataStateNotifier();
});

class UserDataStateNotifier extends StateNotifier<UserData> {
  late ProviderContainer container;

  UserDataStateNotifier() : super(UserData()) {
    container = ProviderContainer();
    refreshData();
  }

  /// Refreshes the current user's profile data as long as the user exists.
  /// 
  /// NOTE: This function will CATCH AND IGNORE any permissions errors and just not update the state.
  void refreshData() async {
    User? user = FirebaseAuth.instance.currentUser;
    final bool loggedIn = container.read(loginStateNotifier);

    try {
      if (loggedIn && user != null) {
        // Get profile data from Firestore
        final profileData = await FirebaseFirestore.instance
          .collection("/users")
          .where("uid", isEqualTo: user.uid)
          .get()
          .then((value) => value.docs[0].data());

        final loadedData = UserDataMapper.fromMap(profileData);

        state = loadedData;
      }
    } catch (e) {
      // NOTE: Empty, we're ignoring auth errors at the moment
    }
  }
}