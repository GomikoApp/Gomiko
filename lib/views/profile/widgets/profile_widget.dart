import 'package:flutter/material.dart';

import 'package:recycle/constants.dart';

class CustomInkWell extends StatelessWidget {
  final Decoration? decoration;
  final Function()? onTap;
  final Widget? leading;
  final Widget? trailing;
  final Widget? title;
  final bool topRight;
  final bool bottomRight;
  final bool topLeft;
  final bool bottomLeft;

  const CustomInkWell({
    super.key,
    this.decoration,
    this.onTap,
    this.leading,
    this.trailing,
    this.title,
    this.topRight = false,
    this.bottomRight = false,
    this.bottomLeft = false,
    this.topLeft = false,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: decoration ??
          BoxDecoration(
            color: primaryGrey,
            borderRadius: BorderRadius.only(
              topLeft: topLeft
                  ? const Radius.circular(20)
                  : const Radius.circular(0),
              topRight: topRight
                  ? const Radius.circular(20)
                  : const Radius.circular(0),
              bottomLeft: bottomLeft
                  ? const Radius.circular(20)
                  : const Radius.circular(0),
              bottomRight: bottomRight
                  ? const Radius.circular(20)
                  : const Radius.circular(0),
            ),
          ),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft:
                topLeft ? const Radius.circular(20) : const Radius.circular(0),
            topRight:
                topRight ? const Radius.circular(20) : const Radius.circular(0),
            bottomLeft: bottomLeft
                ? const Radius.circular(20)
                : const Radius.circular(0),
            bottomRight: bottomRight
                ? const Radius.circular(20)
                : const Radius.circular(0),
          ),
        ),
        onTap: onTap,
        child: ListTile(
          leading: leading,
          trailing: trailing,
          title: title,
        ),
      ),
    );
  }
}
