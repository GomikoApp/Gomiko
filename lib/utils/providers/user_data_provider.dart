/*
  Providers from Riverpod are the way that we load and store data in RAM so that we can use it throughout the app.

  - Authored by Anthony 05/18/24
*/

// firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';

// DATA CLASSES
import 'package:recycle/utils/data_classes.dart';
import 'package:recycle/utils/providers/login_state_provider.dart';

final userDataStreamProvider = StreamProvider<UserData>((ref) {
  final User? user = FirebaseAuth.instance.currentUser;
  final bool loggedIn = ref.watch(applicationStateProvider).loggedIn;

  if (loggedIn) {
    return FirebaseFirestore.instance
        .collection("/users")
        .where("uid", isEqualTo: user!.uid)
        .snapshots()
        .map((snapshot) {
      final profileData = snapshot.docs[0].data();
      return UserDataMapper.fromMap(profileData);
    });
  } else {
    return Stream.value(UserData());
  }
});

final userDataProvider = Provider<UserData>((ref) {
  return ref.watch(userDataStreamProvider).maybeWhen(
        data: (userData) => userData,
        orElse: () => UserData(),
      );
});
