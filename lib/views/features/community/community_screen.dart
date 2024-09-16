import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

// constants
import 'package:recycle/constants.dart';

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
  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userDataProvider);
    final postData = ref.watch(postDataProvider);

    final sortedPostData = postData.map((item) {
      return {
        'username': item['username'] ?? 'Username',
        'location': item['location'] ?? 'Location',
        'content': item['content'] ?? 'Post',
        'image': item['image'],
        'profileImageUrl': item['profileImageUrl'],
        'like': item['like'] ?? 0,
        'comments': item['comments'] ?? [],
        'timestamp': item['timestamp'].toDate(),
      };
    }).toList();

    sortedPostData.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          // TODO:: Create a search bar that filters the posts in firstore

          Expanded(
            child: ListView(
                children: sortedPostData.map<Widget>((data) {
              return Post(
                username: data['username'] ?? 'Username',
                location: data['location'] ?? 'Location',
                post: data['content'] ?? 'Post',
                imageUrl: data['image'],
                profileImageUrl: data['profileImageUrl'],
                like: data['like'] ?? 0,
                comment: data['comments'] ?? [],
                time: data['timestamp'],
              );
            }).toList()),
          ),
        ],
      ),
      // Button to add a new post
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPost(userData: userData),
                  ),
                );
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
