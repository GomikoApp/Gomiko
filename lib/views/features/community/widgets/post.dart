import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class Post extends StatelessWidget {
  final String username;
  final String location;
  final String post;
  final String? imageUrl;
  final String? profileImageUrl;
  final int like;
  final List<dynamic> comment;
  final DateTime time;

  const Post(
      {super.key,
      required this.username,
      required this.location,
      required this.post,
      required this.imageUrl,
      required this.profileImageUrl,
      required this.like,
      required this.comment,
      required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // TODO:: make this a button that navigates to the user's profile
                // retrieve the user's profile image from firestore
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    'https://www.pngfind.com/pngs/m/610-6104451_image-placeholder-png-user-profile-placeholder-image-png.png',
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // retrieve the user's location from their profile in firestore
                    Text(location),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              post,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                // TODO:: make this a button and increment its like in firestore
                const Row(
                  children: [
                    Icon(Icons.favorite),
                    SizedBox(width: 5),
                    Text('0'),
                  ],
                ),
                const SizedBox(width: 10),

                // TODO:: make this button to pull up a bottom sheet modal showing all comments
                const Row(
                  children: [
                    Icon(Icons.comment),
                    SizedBox(width: 5),
                    Text('0'),
                  ],
                ),

                const Spacer(),

                Row(
                  children: [
                    const SizedBox(width: 5),
                    Text(timeago.format(time)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}