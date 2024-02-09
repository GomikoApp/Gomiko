import 'package:flutter/material.dart';

class SocialMediaButton extends StatelessWidget {
  final String assetName;
  final VoidCallback onPressed;

  const SocialMediaButton(
      {super.key, required this.assetName, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xffebf4dc),
      minimumSize: const Size(90, 50),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );

    return ElevatedButton(
      style: style,
      onPressed: onPressed,
      child: Image(
        image: AssetImage(assetName),
        width: 30,
        height: 30,
      ),
    );
  }
}
