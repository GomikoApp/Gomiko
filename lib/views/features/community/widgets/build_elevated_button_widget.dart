import 'package:flutter/material.dart';
import 'package:recycle/constants.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String text;

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGrey,
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(height: 8),
            Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
