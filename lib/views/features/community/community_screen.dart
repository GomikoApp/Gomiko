import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recycle/constants.dart';

class CommunityTab extends StatefulWidget {
  const CommunityTab({super.key});

  @override
  State<CommunityTab> createState() => _CommunityTabState();
}

class _CommunityTabState extends State<CommunityTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Column(
        children: [
          SizedBox(
            height: 20,
          ),
          // TODO:: Create a search bar that filters the posts in firstore

          // TODO:: Show a list of posts from firestore

          // TODO:: Add a button to create a new post
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          height: 70,
          width: 70,
          child: FittedBox(
            child: FloatingActionButton(
              backgroundColor: primaryGreen,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              onPressed: () {
                // TODO: Navigate to a new screen to create a post
              },
              child: const Icon(
                Iconsax.add,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
