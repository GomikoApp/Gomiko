import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

// Riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';

// FirebaseFirestore
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<List<Map<String, dynamic>>> _getPostData() async {
    final postSnapshot =
        await FirebaseFirestore.instance.collection('posts').get();
    final posts = postSnapshot.docs;

    List<Map<String, dynamic>> postData = [];

    for (var post in posts) {
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
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.read(userDataProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _getPostData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return const Center(child: Text('No posts available'));
            }

            final sortedPostData = snapshot.data!;
            sortedPostData
                .sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

            return ListView(
              children: sortedPostData.map<Widget>((data) {
                return Post(
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
                );
              }).toList(),
            );
          },
        ),
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
