import 'package:flutter/material.dart';

class GomikoLogo extends StatelessWidget {
  const GomikoLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 54),
      child: RichText(
        text: const TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: 'GOMI',
              style: TextStyle(
                color: Color(0xffD7E9B9),
                fontSize: 42,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: 'KO',
              style: TextStyle(
                color: Color(0xff95CA4A),
                fontSize: 42,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
