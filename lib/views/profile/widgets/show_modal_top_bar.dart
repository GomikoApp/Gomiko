import 'package:flutter/material.dart';

Widget showModalTopBar() {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
      height: 5,
      width: 50,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

