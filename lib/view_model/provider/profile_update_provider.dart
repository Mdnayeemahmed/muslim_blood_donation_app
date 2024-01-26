import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:muslim_blood_donor_bd/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/paths.dart';
import '../services/database_service.dart';

class ProfileUpdateProvider extends ChangeNotifier {
  final DatabaseService databaseService = DatabaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _updatingInfo = false;
  bool _isAvailable = true;
  String _downloadUrl = '';

  String get downloadUrl => _downloadUrl;


  bool get isAvailable => _isAvailable;

  late StreamController<UserModel> _userStreamController;
  Stream<UserModel> get userStream => _userStreamController.stream;

  bool get isLoading => _updatingInfo;
  UserModel _currentUser = UserModel();

  UserModel get currentUser => _currentUser;

  late DateTime _lastDonateDate;
  late DateTime _updateDate;

  String?uid;

  DateTime get lastDonateDate => _lastDonateDate;
  DateTime get updateDate => _updateDate;


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
    String? reference,
    String? condition,
    String? birthday,
    String? phone,
    String? counter,
    String? name,

  }) async {
    _updatingInfo = true;
    notifyListeners();

    final Map<String, dynamic> updatedData = {};

    if (donateDate != null) {
      updatedData['last_donate_date'] = donateDate;
    }
    if (name != null) {
      updatedData['user_name'] = name;
    }
    if (counter != null) {
      updatedData['blood_count'] = counter;
    }

    if (socialMediaLink != null) {
      updatedData['socialMediaLink'] = socialMediaLink;
    }
    if (phone != null) {
      updatedData['user_phone'] = phone;
    }

    if (reference != null) {
      updatedData['reference'] = reference;
    }

    if (condition != null) {
      updatedData['condition'] = condition;
    }
    if (birthday != null) {
      updatedData['date_of_birth'] = birthday;
    }

    final response = await DatabaseService.update(userCollection, uid, updatedData);
    _updatingInfo = false;
    notifyListeners();

    return response.isSuccess;
  }


  Future<bool> updateCounter({
    required String uid,
    String? counter,
  }) async {
    _updatingInfo = true;
    notifyListeners();

    final Map<String, dynamic> updatedData = {};

    if (counter != null) {
      updatedData['blood_count'] = counter;
    }

    final response = await DatabaseService.update(userCollection, uid, updatedData);
    _updatingInfo = false;
    notifyListeners();

    return response.isSuccess;
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




  Future<bool> deleteUser(String userId, String adminPassword) async {
    try {
      _updatingInfo = true;
      notifyListeners();

      await reauthenticateUser(adminPassword);

      // Delete user from Firebase Authentication

      // Proceed with deleting the user from the database
      final response = await DatabaseService.delete(userCollection, userId);

      _updatingInfo = false;
      notifyListeners();

      return response.isSuccess;
    } catch (error) {
      return false;
    }
  }

  Future<void> reauthenticateUser(String password) async {
    try {
      // Get the current user
      User? user = _auth.currentUser;

      if (user != null) {
        // Get the user's email
        String? email = user.email;

        if (email != null) {
          // Create a credential using the user's email and provided password
          AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);


          // Re-authenticate the user with the credential
          await user.reauthenticateWithCredential(credential);
        } else {
          // Handle the case where the user's email is not available
          throw FirebaseAuthException(
            code: 'missing-email',
            message: 'User email is not available.',
          );
        }
      }
    } catch (error) {
      rethrow;
    }
  }

  void updateStatus(bool newStatus) {
    _isAvailable = newStatus;
    notifyListeners();
  }

  void updateProfilePhotoUrl(String newDownloadUrl) {
    _downloadUrl = newDownloadUrl;
    notifyListeners();
  }

  void updateBirthDate(DateTime date) {
    _updateDate = date;
    notifyListeners();
  }

  void clearDate() {
    _updateDate = DateTime.now();
    notifyListeners();
  }




}
