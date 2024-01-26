import 'dart:io';
import 'package:flutter/material.dart';
import 'package:muslim_blood_donor_bd/view/feed/news_feed.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/navigation.dart';
import '../../view_model/provider/post_provider.dart';

class CreatePost extends StatefulWidget {
  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  String userName = '';
  String uid = '';



  @override
  void initState() {
    super.initState();
    // Retrieve username and uid from SharedPreferences
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? '';
      print(userName);
      uid = prefs.getString('uid') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return _CreatePostWidget(
      userName: userName,
      uid: uid,
    );
  }
}

class _CreatePostWidget extends StatefulWidget {
  final String userName;
  final String uid;

  const _CreatePostWidget({required this.userName, required this.uid});

  @override
  State<_CreatePostWidget> createState() => _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<_CreatePostWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload A Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16),
              GestureDetector(
                onTap: () => _getImage(context),
                child: Consumer<PostProvider>(
                  builder: (context, postProvider, _) {
                    return Container(
                      height: 500,
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: postProvider.imageFile != null
                          ? Image.file(
                              postProvider.imageFile!,
                              fit: BoxFit.fitHeight,
                            )
                          : Center(
                              child: Text('Tap to Pick Image'),
                            ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              Consumer<PostProvider>(
                builder: (context, postProvider, _) {
                  return TextFormField(
                    controller: postProvider.postContentController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'Post Content',
                      hintText: 'What\'s on your mind?',
                      border: OutlineInputBorder(),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _uploadPost(context),
                child: Text('Upload'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getImage(BuildContext context) async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      Provider.of<PostProvider>(context, listen: false)
          .setImage(File(pickedFile.path));
    }
  }
  Future<void> _uploadPost(BuildContext context) async {
    PostProvider postProvider = Provider.of<PostProvider>(context, listen: false);

    String postContent = postProvider.postContentController.text.trim();
    File? imageFile = postProvider.imageFile;

    if (postContent.isEmpty || imageFile == null) {
      // Show an error message if the post content or image is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please provide both post content and an image.'),
        ),
      );
      return;
    }

    // Pass username, uid, post content, and image to uploadPost
    await postProvider.uploadPost(
      widget.uid,
      widget.userName,
    );

    // Navigate to the Newsfeed screen after a successful post upload
    Navigator.of(context).pop(); // Close the current screen
    Navigation.offAll(context, Newsfeed()); // Replace the current screen with the Newsfeed screen
  }


}
