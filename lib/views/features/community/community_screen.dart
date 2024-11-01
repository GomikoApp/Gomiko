import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

// Riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';

// FirebaseFirestore
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recycle/constants.dart';

// Data Classes
import 'package:recycle/utils/providers/user_data_provider.dart';

// widget
import 'package:recycle/views/features/community/widgets/add_post.dart';
import 'package:recycle/views/features/community/widgets/post.dart';

class CommunityTab extends ConsumerStatefulWidget {
  const CommunityTab({super.key});

  @override
  ConsumerState<CommunityTab> createState() => _CommunityTabState();
}

class _CommunityTabState extends ConsumerState<CommunityTab> {
  // fetch user data based on the user's uid
  Future<Map<String, dynamic>> _getUserData(String uid) async {
    final userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return userSnapshot.data() ?? {};
  }

  Stream<List<Map<String, dynamic>>> _getPostStream() {
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap((postSnapshot) async {
      List<Map<String, dynamic>> postData = [];

      for (var post in postSnapshot.docs) {
        final postMap = post.data();
        final userId = postMap['uid'];

        // Fetch user data for the current post
        final userData = await _getUserData(userId);

        postData.add({
          'uid': postMap['uid'],
          'postId': postMap['postId'],
          'username': userData['profile_username'], // from user data
          'location': userData['location'], // from user data
          'content': postMap['content'],
          'image': postMap['image'],
          'profileImageUrl': userData['profile_picture_url'], // from user data
          'likes': postMap['likes'],
          'comments': postMap['comments'],
          'timestamp': postMap['timestamp'].toDate(),
        });
      }

      return postData;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.read(userDataProvider);

    return Scaffold(
      backgroundColor: primaryGrey,
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _getPostStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Check if the snapshot has an error
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // If there's no data and the connection is not waiting
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts available'));
          }

          final sortedPostData = snapshot.data!;

          return ListView.builder(
            itemCount: sortedPostData.length,
            itemBuilder: (context, index) {
              final data = sortedPostData[index];
              return Container(
                margin: index == 0
                    ? const EdgeInsets.only(top: 10)
                    : EdgeInsets.zero,
                child: Post(
                  uid: data['uid'],
                  postId: data['postId'],
                  username: data['username'],
                  location: data['location'],
                  post: data['content'],
                  imageUrl: data['image'],
                  profileImageUrl: data['profileImageUrl'],
                  like: data['likes'],
                  comment: data['comments'],
                  time: data['timestamp'],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddPost(userData: userData)),
          );
        },
        child: const Icon(Iconsax.add),
      ),
    );
  }
}
