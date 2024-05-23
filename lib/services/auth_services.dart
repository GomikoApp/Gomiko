import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recycle/utils/data_classes.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign In With Google
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    final signInCred =
        await FirebaseAuth.instance.signInWithCredential(credential);

    createUserDocument(signInCred);

    return signInCred;
  }

  // Sign In With Facebook
  Future<UserCredential> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;

      final facebookAuthCredential =
          FacebookAuthProvider.credential(accessToken.tokenString);

      final signInCred = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);

      createUserDocument(signInCred);

      return signInCred;
    } else {
      if (kDebugMode) print(result.status);
      if (kDebugMode) print(result.message);
      throw Exception('Facebook Sign In Failed');
    }
  }

  // Sign In With Email and Password
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    return await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential createUserResult =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // User was created successfully because exception was not thrown.
      User? user = _firebaseAuth.currentUser;

      // Send an email verification to the user's email.
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }

      createUserDocument(createUserResult);

      return createUserResult;
    } on FirebaseAuthException catch (e) {
      // Return the error message
      return Future.error(e.message ?? 'An unknown error occurred');
    }
  }

  Future<UserCredential?> signInAsAnonymousUser() async {
    try {
      final result = await FirebaseAuth.instance.signInAnonymously();

      createUserDocument(result);

      return result;
    } on FirebaseAuthException catch (e) {
      return Future.error(e.message ?? 'An unknown error occurred');
    }
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: email.trim(),
    );
  }

  // Add user to users collection in Firestore
  Future<DocumentReference> createUserDocument(
      UserCredential credential) async {
    final User? user = credential.user;

    // Check for duplicate user
    final checkUserResponse = await _firestore
        .collection("/users")
        .where("uid", isEqualTo: user?.uid)
        .get()
        .then((value) => value.docs.firstOrNull);

    if (checkUserResponse != null) {
      return checkUserResponse.reference;
    }

    // Get user data and create a new document
    final userData = UserData.asMap(
        uid: user?.uid,
        email: user?.email,
        name: user?.displayName,
        profilePictureUrl: user?.photoURL,
        profileUsername: user?.displayName,
        oauthProvider: credential.credential?.signInMethod);

    final response = await _firestore.collection("/users").add(userData);

    return response;
  }
}
