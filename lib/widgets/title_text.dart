import "package:flutter/material.dart";

/// The [Text] that denotes the title of the page for the login/signup page sequence.
class TitleText extends StatelessWidget {
  /// Creates a [TitleText].
  ///
  /// Default [fontWeight] is [FontWeight.bold], though you can override it to become [FontWeight.normal].
  const TitleText(
      {Key? key,
      required this.text,
      this.fontColor = Colors.black,
      this.fontSize = 40,
      this.overrideBold = false})
      : super(key: key);

  final String text;
  final double fontSize;
  final Color fontColor;
  final bool overrideBold;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: fontColor,
        fontSize: fontSize,
        fontWeight: overrideBold == true ? FontWeight.normal : FontWeight.bold,
      ),
    );
  }
}
