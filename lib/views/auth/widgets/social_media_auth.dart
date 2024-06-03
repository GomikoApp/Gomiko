import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Widgets
import 'login_signup_widgets.dart';
import 'social_media_button.dart';

class SocialMediaAuth extends StatelessWidget {
  final VoidCallback onAnonymousSignIn;
  final VoidCallback onGoogleSignIn;
  final VoidCallback onFacebookSignIn;

  const SocialMediaAuth({
    super.key,
    required this.onAnonymousSignIn,
    required this.onGoogleSignIn,
    required this.onFacebookSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SocialMediaButton(
            assetName: 'assets/logos/Google-Logo.png',
            onPressed: () {
              onGoogleSignIn();
              if (kDebugMode) print("Google Sign In");
            },
          ),
          const SizedBox(width: 20),
          SocialMediaButton(
            assetName: 'assets/logos/Facebook-Logo.png',
            onPressed: () {
              onFacebookSignIn();
              if (kDebugMode) print("Facebook Sign In");
            },
          ),
          const SizedBox(width: 20),
          SocialMediaButton(
            assetName: 'assets/logos/Apple-Logo.png',
            onPressed: () {
              if (kDebugMode) print("Apple Sign In");
            },
          ),
        ],
      ),
      const SizedBox(height: 20),
      GomikoLink(
        label: "Continue without an account",
        onTap: onAnonymousSignIn,
      ),
    ]);
  }
}
