import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:muslim_blood_donor_bd/constant/assets_path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/navigation.dart';
import 'create_post.dart';

class Newsfeed extends StatefulWidget {
  const Newsfeed({Key? key}) : super(key: key);

  @override
  State<Newsfeed> createState() => _NewsfeedState();
}

class _NewsfeedState extends State<Newsfeed> {
  bool isAdmin = false;
  late Box _postBox;

  @override
  void initState() {
    super.initState();
    loadIsAdminStatus();
    _openBox();
  }

  Future<void> _openBox() async {
    _postBox = await Hive.openBox('posts');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('NewsFeed'),
        ),
        body: _buildNewsFeed(),
        floatingActionButton: isAdmin
            ? FloatingActionButton.extended(
                onPressed: () {
                  Navigation.to(context, CreatePost());
                },
                label: const Text('Add'),
                icon: const Icon(Icons.add),
              )
            : null);
  }

  Widget _buildNewsFeed() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        List<DocumentSnapshot> documents = snapshot.data!.docs;

        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            var post = documents[index];
            return _buildPostCard(post);
          },
        );
      },
    );
  }

  Widget _buildPostCard(DocumentSnapshot post) {
    Timestamp timestamp = post['timestamp'];
    DateTime dateTime = timestamp.toDate();

    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Image.asset(AssetsPath.user),
            ),
            title: Text(
              post['username'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(_formatTimestamp(dateTime)),
          ),
          if (post['imageURL'] != null)
            CachedNetworkImage(
              imageUrl: post['imageURL'],
              height: 500,
              width: double.infinity,
              fit: BoxFit.fitHeight,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(post['postContent']),
          ),
          if (isAdmin)
            ElevatedButton(
              onPressed: () async {
                bool? confirmDelete = await showDeleteConfirmation(
                    context, post.id, post['imageURL']);
                if (confirmDelete ?? false) {
                  _deletePost(post.id, post['imageURL']);
                }
              },
              child: const Text('Delete Post'),
            ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime dateTime) {
    Duration timeAgo = DateTime.now().difference(dateTime);

    if (timeAgo.inDays > 0) {
      return '${timeAgo.inDays}d ago';
    } else if (timeAgo.inHours > 0) {
      return '${timeAgo.inHours}h ago';
    } else if (timeAgo.inMinutes > 0) {
      return '${timeAgo.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  Future<void> _deletePost(String postId, String? imageURL) async {
    await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
    if (imageURL != null) {
      await firebase_storage.FirebaseStorage.instance
          .refFromURL(imageURL)
          .delete();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post deleted successfully')),
    );
  }

  Future<void> loadIsAdminStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isAdmin = prefs.getBool('isAdmin') ?? false;
    });
  }

  Future<bool?> showDeleteConfirmation(
      BuildContext context, String postId, String? imageURL) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this post?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User canceled the deletion
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed the deletion
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
