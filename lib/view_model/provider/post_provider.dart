import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PostProvider extends ChangeNotifier {
  TextEditingController postContentController = TextEditingController();
  File? imageFile;

  void setImage(File? image) {
    imageFile = image;
    notifyListeners();
  }

  void clearData() {
    postContentController.clear();
    imageFile = null;
    notifyListeners();
  }

  Future<void> uploadPost(String userUid, String username) async {
    String postContent = postContentController.text;

    if (imageFile != null) {
      Reference storageReference =
      FirebaseStorage.instance.ref().child('images/${DateTime.now()}.png');
      UploadTask uploadTask = storageReference.putFile(imageFile!);
      await uploadTask.whenComplete(() => print('Image uploaded'));

      String imageURL = await storageReference.getDownloadURL();

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Timestamp timestamp = Timestamp.now();
        FirebaseFirestore.instance.collection('posts').add({
          'userId': userUid, // Use the user UID from shared preferences
          'username': username, // Use the username from shared preferences
          'postContent': postContent,
          'imageURL': imageURL,
          'timestamp': timestamp,
        });
        print('Post added to Firestore');
      }
    } else {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Timestamp timestamp = Timestamp.now();
        FirebaseFirestore.instance.collection('posts').add({
          'userId': userUid, // Use the user UID from shared preferences
          'username': username, // Use the username from shared preferences
          'postContent': postContent,
          'timestamp': timestamp,
        });
        print('Post added to Firestore');
      }
    }

    // Clear data after upload
    clearData();
  }
}
