import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recycle/constants.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:like_button/like_button.dart';

class Post extends StatefulWidget {
  final String uid;
  final String username;
  final String location;
  final String post;
  final String? imageUrl;
  final String? profileImageUrl;
  final List<dynamic> like;
  final List<dynamic> comment;
  final DateTime time;
  final String postId;

  const Post({
    super.key,
    required this.uid,
    required this.username,
    required this.location,
    required this.post,
    required this.imageUrl,
    required this.profileImageUrl,
    required this.like,
    required this.comment,
    required this.time,
    required this.postId,
  });

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    final postRef =
        FirebaseFirestore.instance.collection('posts').doc(widget.postId);
    if (isLiked) {
      postRef.update({
        'likes': FieldValue.arrayRemove([user!.uid]),
      });
    } else {
      postRef.update({
        'likes': FieldValue.arrayUnion([user!.uid]),
      });
    }
    return !isLiked;
  }

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
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    widget.profileImageUrl ??
                        'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png',
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // retrieve the user's location from their profile in firestore
                    Text(widget.location),
                  ],
                ),
                // Make a hamburger menu that allows user to edit their posts or delete their posts
                const Spacer(),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          height: Constants.windowHeight(context) * 0.2,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // add a small oval container to show it is scrollable
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  height: 5,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),

                              (user!.uid == widget.uid)
                                  ? Column(
                                      children: [
                                        ListTile(
                                          title:
                                              const Center(child: Text('Edit')),
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          title: const Center(
                                              child: Text('Delete')),
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          title: const Center(
                                              child: Text('Cancel')),
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        ListTile(
                                          title: const Center(
                                              child: Text('Report')),
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          title: const Center(
                                              child: Text('Cancel')),
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.more_horiz),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              widget.post,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Row(
                  children: [
                    LikeButton(
                      circleColor:
                          const CircleColor(start: Colors.red, end: Colors.red),
                      bubblesColor: const BubblesColor(
                        dotPrimaryColor: Colors.red,
                        dotSecondaryColor: Colors.red,
                      ),
                      likeCount: widget.like.length,
                      isLiked: widget.like.contains(user!.uid),
                      likeBuilder: (bool isLiked) {
                        return Icon(
                          isLiked ? Icons.favorite : Iconsax.heart,
                          color: isLiked ? Colors.red : Colors.black,
                        );
                      },
                      countBuilder: (int? count, bool isLiked, String text) {
                        var color = isLiked ? Colors.red : Colors.black;
                        Widget result;
                        result = Text(
                          text,
                          style: TextStyle(color: color),
                        );
                        return result;
                      },
                      onTap: onLikeButtonTapped,
                    ),
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
                    Text(timeago.format(widget.time)),
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
