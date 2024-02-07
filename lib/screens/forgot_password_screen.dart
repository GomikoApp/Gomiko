import "package:flutter/material.dart";

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/backgrounds/Forgot-Password.png'),
              fit: BoxFit.fill,
            ),
          ),
        )
      ],
    );
  }
}
