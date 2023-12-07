import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:muslim_blood_donor_bd/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/paths.dart';
import '../services/database_service.dart';

class ProfileUpdateProvider extends ChangeNotifier {
  final DatabaseService databaseService = DatabaseService();
  bool _updatingInfo = false;

  late StreamController<UserModel> _userStreamController;
  Stream<UserModel> get userStream => _userStreamController.stream;

  bool get isLoading => _updatingInfo;
  UserModel _currentUser = UserModel();

  UserModel get currentUser => _currentUser;

  late DateTime _lastDonateDate;
  String?uid;

  DateTime get lastDonateDate => _lastDonateDate;

  String userCollection = Paths.database.collectionUser;

  ProfileUpdateProvider() {
    _userStreamController = StreamController<UserModel>();
  }

  @override
  void dispose() {
    _userStreamController.close();
    super.dispose();
  }

  Future<bool> update({
    required String uid,
    String? donateDate,
    String? socialMediaLink,
  }) async {
    _updatingInfo = true;
    notifyListeners();

    final Map<String, dynamic> updatedData = {};

    if (donateDate != null) {
      updatedData['last_donate_date'] = donateDate;
    }

    if (socialMediaLink != null) {
      updatedData['socialMediaLink'] = socialMediaLink;
    }

    final response =
    await DatabaseService.update(userCollection, uid, updatedData);
    _updatingInfo = false;
    notifyListeners();

    if (response.isSuccess) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> getCurrentUser() async {
    try {
      _updatingInfo = true;
      notifyListeners();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? uid = prefs.getString('uid');

      final response = await DatabaseService.read(
        userCollection,
        uid!,
      );

      if (response.isSuccess) {
        _currentUser = UserModel.fromJson(
          response.body ?? {},
        );
        _userStreamController.add(_currentUser);
      }

      _updatingInfo = false;
    } finally {
      notifyListeners();
    }
  }

  void updateLastDonateDate(DateTime date) {
    _lastDonateDate = date;
    notifyListeners();
  }

  void clearLastDonateDate() {
    _lastDonateDate = DateTime.now();
    notifyListeners();
  }

  Future<void> getuid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');
  }
}
