import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
    final checkUserResponse =
        await _firestore.collection("/users").doc(user?.uid).get();

    if (checkUserResponse.exists) {
      return checkUserResponse.reference;
    }

    // Get user data and create a new document
    // Made name and profileUsername have default value as it can't be null
    final userData = UserData.asMap(
        uid: user?.uid,
        email: user?.email,
        name: user?.displayName ?? "User",
        profilePictureUrl: user?.photoURL,
        profileUsername: user?.displayName ?? "User",
        oauthProvider: credential.credential?.signInMethod);

    await _firestore.collection("/users").doc(user?.uid).set(userData);

    return _firestore.collection("/users").doc(user?.uid);
  }

  Future<void> deleteAccount() async {
    try {
      // Get current user
      User? user = FirebaseAuth.instance.currentUser;
      String uid = user!.uid;

      // Fetch and delete user's posts
      QuerySnapshot postsSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: uid)
          .get();

      for (QueryDocumentSnapshot post in postsSnapshot.docs) {
        String? imageUrl = post['image'];
        if (imageUrl != null && imageUrl.isNotEmpty) {
          try {
            Reference imageRef = FirebaseStorage.instance.refFromURL(imageUrl);
            await imageRef.delete();
          } catch (e) {
            if (kDebugMode) {
              print('Failed to delete image: $e');
            }
          }
        }
        await post.reference.delete();
      }

      // Delete user data from Firestore 'users' collection
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();

      // Attempt to delete user from Firebase Authentication
      await user.delete();

      if (kDebugMode) {
        print("Account deleted successfully");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        if (kDebugMode) {
          print("Re-authentication required: $e");
        }

        // Re-authenticate the user based on their auth provider
        String providerId =
            FirebaseAuth.instance.currentUser!.providerData[0].providerId;

        if (providerId == 'google.com') {
          await _reauthenticateWithGoogle();
        } else if (providerId == 'facebook.com') {
          await _reauthenticateWithFacebook();
        } else if (providerId == 'password') {
          //await _reauthenticateWithPassword();
        }

        // After successful re-authentication, retry account deletion
        await deleteAccount();
      } else {
        if (kDebugMode) {
          print("Failed to delete account: $e");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting account: $e");
      }
    }
  }

  Future<void> _reauthenticateWithGoogle() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      // sign in user with google again
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // create googl eauth credential
      final googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // reauthenticate user
      await user!.reauthenticateWithCredential(googleCredential);

      if (kDebugMode) {
        print("User reauthenticated successfully");
      }
    } catch (e) {
      // show error message
      if (kDebugMode) {
        print("Failed to reauthenticate");
      }
    }
  }

  Future<void> _reauthenticateWithFacebook() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      // sign in user with facebook again
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final facebookAuthCredential =
            FacebookAuthProvider.credential(accessToken.tokenString);
        // reauthenticate user
        await user!.reauthenticateWithCredential(facebookAuthCredential);
        if (kDebugMode) {
          print("User reauthenticated successfully");
        }
      } else {
        if (kDebugMode) {
          print("Failed to reauthenticate");
        }
      }
    } catch (e) {
      // show error message
      if (kDebugMode) {
        print("Failed to reauthenticate");
      }
    }
  }

  // TODO:: implement reauthenticate with password (need a way to securly fetch user's password)
  // Future<void> _reauthenticateWithPassword() {}
}
