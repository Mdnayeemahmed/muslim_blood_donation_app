import 'package:flutter/material.dart';

class UserProfileProvider extends ChangeNotifier {
  Map<String, dynamic>? userData;

  void updateUserData(Map<String, dynamic> newData) {
    userData = newData;
    notifyListeners();
  }
}