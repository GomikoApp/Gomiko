import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:recycle/constants.dart';
import 'package:go_router/go_router.dart';

class BuildDeleteAccount extends StatelessWidget {
  const BuildDeleteAccount({
    super.key,
    required this.windowWidth,
    required this.windowHeight,
  });

  final double windowWidth;
  final double windowHeight;

  Future<void> deleteAccount() async {
    try {
      // delete all posts by user
      String uid = FirebaseAuth.instance.currentUser!.uid;

      QuerySnapshot postsSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: uid)
          .get();

      // for each post, delete the post and the corresponding images in firebase storage
      for (QueryDocumentSnapshot post in postsSnapshot.docs) {
        // if the posts has images, delete them
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

        // delete the post from firestore
        await post.reference.delete();
      }

      // delete user data from firestore user collection
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();

      // delete user from firebase auth
      await FirebaseAuth.instance.currentUser!.delete();

      if (kDebugMode) {
        print("Account deleted successfully");
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print("Failed to delete account: $e");
      }

      // show error message
      if (e.code == 'requires-recent-login') {
        // reauthenticate and delete account
        await _reauthenticateAndDelete();
      } else {
        // handle other errors
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to delete account: $e");
      }
      // show error message
    }
  }

  Future<void> _reauthenticateAndDelete() async {
    try {
      final providerData =
          FirebaseAuth.instance.currentUser?.providerData.first;

      // TODO:: Not sure if these works, need to wait for error for requires-recent-login
      if (GoogleAuthProvider().providerId == providerData!.providerId) {
        await FirebaseAuth.instance.currentUser!.reauthenticateWithPopup(
          GoogleAuthProvider(),
        );
      } else if (FacebookAuthProvider().providerId == providerData.providerId) {
        await FirebaseAuth.instance.currentUser!.reauthenticateWithPopup(
          FacebookAuthProvider(),
        );
      }
    } catch (e) {
      // show error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: windowWidth,
      height: windowHeight * 0.055,
      padding: const EdgeInsets.only(
        top: 10.0,
      ),
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Delete Account'),
                content: const Text(
                  'Are you sure you want to delete your account?',
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      // delete account
                      deleteAccount();
                      // nvaigate to login screen
                      context.pushReplacement('/login');
                    },
                    child: const Text('Delete'),
                  ),
                ],
              );
            },
          );
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: primaryRed,
        ),
        child: const Text(
          'Delete Account',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
