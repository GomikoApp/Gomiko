import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recycle/views/profile/widgets/show_modal_top_bar.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:like_button/like_button.dart';

// Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Constants
import 'package:recycle/constants.dart';

// Widgets
import 'package:recycle/views/profile/widgets/custom_ink_well_widget.dart';
import 'elevated_button_widget.dart';

// ignore: must_be_immutable
class Post extends ConsumerStatefulWidget {
  final String uid;
  final String username;
  final String location;
  final String post;
  final String? imageUrl;
  final String? profileImageUrl;
  final List<dynamic> like;
  List<dynamic> comment;
  final DateTime time;
  final String postId;

  Post({
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
  ConsumerState<Post> createState() => _PostState();
}

class _PostState extends ConsumerState<Post> {
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

  // build the header of the post
  Widget _buildHeader() {
    return Row(
      children: [
        // TODO: make this a button that navigates to the user's profile
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
                                        decoration: const BoxDecoration(
                                          color: primaryGrey,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
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

  // show bottom modal sheet to show comments
  void showModalBottomCommentSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            // sort comments by time
            widget.comment.sort((a, b) => b['time'].compareTo(a['time']));

            final controller = TextEditingController();
            final postRef = FirebaseFirestore.instance
                .collection('posts')
                .doc(widget.postId);

            // fetch comments from the post
            Future<void> fetchComments() async {
              final postSnapshot = await postRef.get();
              final comments = postSnapshot.data()?['comments'];
              setState(() {
                widget.comment = comments;
              });
            }

            // add comment to the post
            Future<void> onCommentTapped(String commentText) async {
              final userRef =
                  FirebaseFirestore.instance.collection('users').doc(user!.uid);
              final userSnapshot = await userRef.get();
              final username = userSnapshot.data()?['profile_username'];
              final profileImageUrl =
                  userSnapshot.data()?['profile_picture_url'];

              postRef.update({
                'comments': FieldValue.arrayUnion([
                  {
                    'username': username,
                    'profile_image_url': profileImageUrl,
                    'comment': commentText,
                    'time': DateTime.now(),
                  }
                ]),
              });
              fetchComments();
            }

            return DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.6,
              maxChildSize: 0.9,
              snap: true,
              expand: false,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Column(
                  children: [
                    // Custom top bar or handle
                    Container(
                      alignment: Alignment.center,
                      child: showModalTopBar(),
                    ),
                    const Text("Comments",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Expanded(
                      child: widget.comment.isEmpty
                          ? const Center(
                              child: Text(
                              'No comments',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ))
                          : ListView.builder(
                              controller: scrollController,
                              itemCount: widget.comment.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(widget
                                                .comment[index]
                                            ['profile_image_url'] ??
                                        'http://www.gravatar.com/avatar/?d=mp'),
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        Text(
                                          widget.comment[index]['username'],
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),

                                        // add a small dot
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 4.0, right: 4.0),
                                          child: Icon(Icons.circle, size: 5),
                                        ),

                                        Text(
                                          timeago.format(widget.comment[index]
                                                  ['time']
                                              .toDate()),
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ]),
                                      Text(widget.comment[index]['comment'],
                                          style: const TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(fontSize: 14),
                          hintText: 'Add a comment...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          suffixIcon: IconButton(
                            onPressed: () async {
                              if (controller.text.isEmpty) {
                                return;
                              } else {
                                await onCommentTapped(controller.text);
                              }
                            },
                            icon: const Icon(Iconsax.send_1),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
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

        Row(
          children: [
            IconButton(
              onPressed: () {
                showModalBottomCommentSheet(context);
              },
              icon: const Icon(Iconsax.message),
            ),
            Transform.translate(
              offset: const Offset(-7, 0),
              child: Text("${widget.comment.length}"),
            ),
          ],
        ),
        const Spacer(),

        // Save post utilizing the like button package
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
}
