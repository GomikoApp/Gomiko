import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// iconsax
import 'package:iconsax/iconsax.dart';

// firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// constants
import 'package:recycle/constants.dart';

// image packages
import 'package:image_picker/image_picker.dart';
import 'package:recycle/utils/data_classes.dart';

class AddPost extends StatefulWidget {
  const AddPost({
    super.key,
    required this.userData,
  });

  final Map<String, dynamic> userData;

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final int _maxLength = 280;
  final TextEditingController _controller = TextEditingController();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  bool _isLoading = false;

  // keep track of current length of text
  int _currentLength = 0;

  // global file variable to store the image
  File? _selectedImage;

  Future<void> _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (returnedImage != null) {
        _selectedImage = File(returnedImage.path);
      }
    });
  }

  Future<void> _pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      if (returnedImage != null) {
        _selectedImage = File(returnedImage.path);
      }
    });
  }

  // upload post to firebase with image being optional
  Future<void> _uploadPost() async {
    setState(() {
      _isLoading = true;
    });

    CollectionReference posts = FirebaseFirestore.instance.collection('posts');
    String? downloadUrl;

    if (_selectedImage != null) {
      // create reference to the file location in firebase storage
      Reference storageRef =
          _storage.ref().child('posts/${_selectedImage!.path}');

      // start file upload
      UploadTask uploadTask = storageRef.putFile(_selectedImage!);

      // wait for upload to complete and get downloadUrl
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      downloadUrl = await snapshot.ref.getDownloadURL();
    }

    String uid = widget.userData[UserData.keyUid];
    String username = widget.userData[UserData.keyProfileUsername];

    String postId = posts.doc().id;

    // add post to firebase
    Map<String, dynamic> postData = {
      'uid': uid,
      'postId': postId,
      'username': username,
      'content': _controller.text,
      'image': downloadUrl,
      'likes': [],
      'comments': [],
      'timestamp': FieldValue.serverTimestamp(),
    };

    await posts.doc(postId).set(postData).then((value) async {
      if (kDebugMode) {
        print('Post added with postID: $postId');
      }
    }).catchError((error) {
      if (kDebugMode) {
        print('Error adding post: $error');
      }
    });

    // add a delay
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      setState(() {
        _currentLength = _controller.text.length;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // button to submit Post
  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.only(
          left: 20.0, right: 20.0, top: 10.0, bottom: 20.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () async {
            if (_currentLength > _maxLength) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Post is too long'),
                ),
              );
              return;
            } else if (_currentLength == 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Post cannot be empty'),
                ),
              );
            } else {
              _uploadPost();
            }
          },
          child: const Text(
            "Post",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  // show selected image
  Widget _buildShowSelectedImage() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 10.0),
      child: SizedBox(
        height: 80,
        width: 80,
        child: Stack(
          clipBehavior: Clip
              .none, // Allows the icon to be positioned outside the container
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: FileImage(_selectedImage!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: -5,
              right: -5,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 10,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Iconsax.close_circle,
                      size: 15, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _selectedImage = null;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // show modal bottom sheet to select image from camera or gallery
  void _buildShowModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SizedBox(
          height: Constants.windowHeight(context) * 0.2,
          child: Column(
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

              ListTile(
                title: const Center(
                    child: Text(
                  'Choose Photo',
                )),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImageFromGallery();
                },
              ),

              ListTile(
                title: const Center(
                    child: Text(
                  'Take Photo',
                )),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImageFromCamera();
                },
              ),

              ListTile(
                title: const Center(
                    child: Text(
                  'Cancel',
                )),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildSelectImageButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 10.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          height: 80,
          width: 80,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.grey[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              // show bottom modal sheet for options to select camera/gallery
              _buildShowModalBottomSheet(context);
            },
            child: const Icon(Iconsax.camera5),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Post'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                child: TextField(
                  controller: _controller,
                  maxLines: 10,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintText: 'What\'s on your mind?',
                    contentPadding: const EdgeInsets.all(20.0),
                  ),
                ),
              ),
              // text length counter
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '$_currentLength/$_maxLength',
                    style: TextStyle(
                      color: _currentLength > _maxLength
                          ? Colors.red
                          : Colors.grey,
                    ),
                  ),
                ),
              ),

              // Add image button
              Row(
                children: [
                  // add selected images here make the size the same as the camera elevation button
                  if (_selectedImage != null) _buildShowSelectedImage(),
                  _buildSelectImageButton(context),
                ],
              ),

              const Spacer(),

              _buildSubmitButton(),
            ],
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
