import 'package:flutter/material.dart';
import 'package:recycle/constants.dart';

class LearnTab extends StatefulWidget {
  const LearnTab({super.key});

  @override
  State<LearnTab> createState() => _LearnTabState();
}

class _LearnTabState extends State<LearnTab> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: primaryGrey,
      body: Center(
        child: Text('Learn Page'),
      ),
    );
  }
}
