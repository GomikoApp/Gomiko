import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recycle/constants.dart';
import 'package:recycle/views/profile/widgets/profile_widget.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:like_button/like_button.dart';
import 'build_elevated_button_widget.dart';

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
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    _checkIfSaved();
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

  Future<void> _checkIfSaved() async {
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);
    final userSnapshot = await userRef.get();
    final savedPosts = userSnapshot.data()?['saved_posts'] ?? [];
    setState(() {
      isSaved = savedPosts.contains(widget.postId);
    });
  }

  // save the post id to the user's saved posts collection when the user clicks the save button
  // if user clicks the save button again, remove the post id from the user's saved posts collection
  Future<bool> onSavePostTapped(bool isSaved) async {
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);
    if (!isSaved) {
      userRef.update({
        'saved_posts': FieldValue.arrayUnion([widget.postId]),
      });
    } else {
      userRef.update({
        'saved_posts': FieldValue.arrayRemove([widget.postId]),
      });
    }
    return !isSaved;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 0,
        bottom: 10,
      ),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 10),
          _buildContent(),
          _buildActionButtons(), // like, comment, share
        ],
      ),
    );
  }

  // build the header of the post
  Widget _buildHeader() {
    return Row(
      children: [
        // TODO:: make this a button that navigates to the user's profile
        // retrieve the user's profile image from firestore
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(
              widget.profileImageUrl ?? 'http://www.gravatar.com/avatar/?d=mp'),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "@${widget.username}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                // add a small dot
                const Padding(
                  padding: EdgeInsets.only(left: 4.0, right: 4.0),
                  child: Icon(Icons.circle, size: 5),
                ),

                Row(
                  children: [
                    Text(timeago.format(widget.time),
                        style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ],
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
              backgroundColor: Colors.white,
              context: context,
              builder: (context) {
                return SizedBox(
                  height: Constants.windowHeight(context) * 0.3,
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
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // Edit Post
                                      CustomElevatedButton(
                                        onPressed: () {},
                                        icon: Iconsax.edit,
                                        text: "Edit",
                                      ),
                                      const SizedBox(width: 15),
                                      // Delete Post
                                      CustomElevatedButton(
                                        onPressed: () {},
                                        icon: Iconsax.trash,
                                        text: "Delete",
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25.0, right: 25.0),
                                  child: Column(
                                    children: [
                                      // Cancel Button
                                      CustomInkWell(
                                        bottomRight: true,
                                        bottomLeft: true,
                                        topLeft: true,
                                        topRight: true,
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        leading: const Icon(
                                            Icons.keyboard_arrow_left),
                                        title: const Text("Cancel"),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15.0),
                                  child: Column(
                                    children: [
                                      // Save Posts to Collection
                                      CustomInkWell(
                                        topLeft: true,
                                        topRight: true,
                                        bottomRight: true,
                                        bottomLeft: true,
                                        onTap: () {},
                                        leading:
                                            const Icon(Iconsax.archive_add),
                                        title: const Text("Save"),
                                      ),
                                      const SizedBox(height: 10),
                                      // Report Posts
                                      CustomInkWell(
                                        topLeft: true,
                                        topRight: true,
                                        onTap: () {},
                                        leading:
                                            const Icon(Iconsax.shield_cross),
                                        title: const Text("Report"),
                                      ),
                                      // Cancel Posts
                                      CustomInkWell(
                                        bottomRight: true,
                                        bottomLeft: true,
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        leading: const Icon(
                                            Icons.keyboard_arrow_left),
                                        title: const Text("Cancel"),
                                      ),
                                    ],
                                  ),
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
    );
  }

  // build the content of the post
  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.post,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),

        // show the image if there is one
        if (widget.imageUrl != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                child: Image.network(
                  widget.imageUrl!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // build the action buttons of the post
  Widget _buildActionButtons() {
    return Row(
      children: [
        LikeButton(
          circleColor: const CircleColor(start: Colors.red, end: Colors.red),
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

        // TODO: Pull a show bottom modal sheet to show comments
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Iconsax.message),
            ),
            Transform.translate(
              offset: const Offset(-7, 0),
              child: Text("${widget.comment.length}"),
            ),
          ],
        ),
        const Spacer(),
        // TODO:: icon to save post
        LikeButton(
          circleColor: const CircleColor(start: Colors.red, end: Colors.red),
          bubblesColor: const BubblesColor(
            dotPrimaryColor: Colors.red,
            dotSecondaryColor: Colors.red,
          ),
          isLiked: isSaved,
          likeBuilder: (bool isSaved) {
            return Icon(
              isSaved ? Iconsax.archive_tick1 : Iconsax.archive_add,
            );
          },
          onTap: onSavePostTapped,
        ),
      ],
    );
  }
}
