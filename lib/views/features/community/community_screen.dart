import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

// Riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';

// FirebaseFirestore
import 'package:cloud_firestore/cloud_firestore.dart';

// constants
import 'package:recycle/utils/data_classes.dart';

// Data Classes
import 'package:recycle/utils/providers/post_data_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final postData = ref.watch(postDataProvider);

    final userData = ref.read(userDataProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: Future.wait(postData.map((post) async {
            final userId = post['uid'];
            final userData = await _getUserData(userId);

            return {
              'postId': post['postId'],
              'username': userData[UserData.keyProfileUsername],
              'location': userData[UserData.keyLocation],
              'content': post['content'],
              'image': post['image'],
              'profileImageUrl': userData[UserData.keyProfilePictureUrl],
              'like': post['likes'],
              'comments': post['comments'],
              'timestamp': post['timestamp'].toDate(),
            };
          }).toList()),
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
                  postId: data['postId'],
                  username: data['username'],
                  location: data['location'],
                  post: data['content'],
                  imageUrl: data['image'],
                  profileImageUrl: data['profileImageUrl'],
                  like: data['like'],
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
