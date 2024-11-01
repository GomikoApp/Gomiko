import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// services
import 'package:recycle/services/auth_services.dart';

// constants
import 'package:recycle/constants.dart';

class BuildDeleteAccount extends StatelessWidget {
  const BuildDeleteAccount({
    super.key,
    required this.windowWidth,
    required this.windowHeight,
  });

  final double windowWidth;
  final double windowHeight;

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
                    onPressed: () async {
                      // delete account
                      AuthService().deleteAccount();
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
