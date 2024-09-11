import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recycle/constants.dart';

// image packages
import 'package:image_picker/image_picker.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final int _maxLength = 10;
  final TextEditingController _controller = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Post'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
            child: TextField(
              controller: _controller,
              maxLines: 10,
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.grey[200],
                hintText: 'What\'s on your mind?',
                contentPadding: const EdgeInsets.all(10.0),
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
                  color: _currentLength > _maxLength ? Colors.red : Colors.grey,
                ),
              ),
            ),
          ),

          // Add image button
          Row(
            children: [
              // add selected images here make the size the same as the camera elevation button
              if (_selectedImage != null)
                Padding(
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
                ),

              Padding(
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // show bottom modal sheet for options to select camera/gallery
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
                                    onTap: () async {},
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: const Icon(Iconsax.camera5),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // TODO: Add Tags? (Optional feature)

          const Spacer(),

          // button to submit Post
          Padding(
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
                onPressed: () {
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
                  }
                  print('Post submitted');
                },
                child: const Text(
                  "Post",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
