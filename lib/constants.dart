import "package:flutter/material.dart";

// Colors
const Color primaryGreen = Color(0xFF95CA4A);
const Color primaryGrey = Color(0xFFeeeeee);
const Color secondaryGray = Color(0xFF6E7191);
const Color primaryRed = Color(0xFFF25555);
const Color bgColor = Color(0xFFF7F7F8);

class Constants {
  static String keyLoggedIn = "loggedIn";

  static double windowHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double windowWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}
