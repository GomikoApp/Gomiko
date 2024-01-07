import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double width;
  final double height;
  final double progress;
  final Color color;
  final Color backgroundColor;

  const ProgressBar({
    Key? key,
    this.width = 200,
    this.height = 10,
    this.progress = 0.0,
    this.color = Colors.blue,
    this.backgroundColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Stack(
          children: [
            Container(
              width: width,
              height: height,
              color: backgroundColor,
            ),
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                width: width,
                height: height,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
