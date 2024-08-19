import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      // delete user data from firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .delete();
      await FirebaseAuth.instance.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Failed to delete account: $e');
      }

      if (e.code == 'requires-recent-login') {
        await _reauthenticateAndDelete();
      } else {
        // show error message
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to delete account: $e');
      }
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
