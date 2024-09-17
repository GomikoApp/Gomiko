// firebase
import 'package:cloud_firestore/cloud_firestore.dart';

// riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recycle/utils/providers/login_state_provider.dart';

// stream data from all posts in firestore
final postDataStreamProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
  final bool loggedIn = ref.watch(applicationStateProvider).loggedIn;
  if (loggedIn) {
    return FirebaseFirestore.instance
        .collection("/posts")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  } else {
    return Stream.value([]);
  }
});

final postDataProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(postDataStreamProvider).maybeWhen(
        data: (postData) => postData,
        orElse: () => [],
      );
});
