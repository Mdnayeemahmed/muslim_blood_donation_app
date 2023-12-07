import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/user_model.dart';
import '../helper/paths.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/shared_prefernce.dart';

class AuthProviders extends ChangeNotifier {
  final AuthService authService = AuthService();
  final DatabaseService databaseService = DatabaseService();

  String? userID;
  bool _isLoading = false;
  String? errorMessage;
  String userCollection = Paths.database.collectionUser;

  bool _authenticated = false;

  bool get isLoading => _isLoading;

  bool get isAuthenticated => _authenticated;

  UserModel _currentUser = UserModel();

  UserModel get currentUser => _currentUser;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final response = await AuthService.login(email, password);
    _isLoading = false;
    notifyListeners();

    if (response.isSuccess) {
      userID = response.body?["user_id"];
      writeUid(userID!);
      await _token();
      //await getCurrentUser(userID!);
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(
      String email,
      password,
      String name,
      String phone,
      String divison,
      String district,
      String area,
      String blood,
      {bool? admin}) async {
    _isLoading = true;
    notifyListeners();

    final response = await AuthService.createAuth(email, password);

    _isLoading = false;

    if (response.isSuccess) {
      userID = response.body?["user_id"] as String;
      writeUid(userID!);
      await _token();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? deviceToken = prefs.getString('deviceToken');
      print(deviceToken);
      final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      String formattedCreatedTime = formatter.format(DateTime.now());
      String formattedLastUpdateTime = formatter.format(DateTime.now());

      UserModel user = UserModel(
          userId: userID,
          userEmail: email,
          userName: name,
          userDeviceTokens: deviceToken,
          createdTime: formattedCreatedTime,
          lastUpdateTime: formattedLastUpdateTime,
          userPhone: phone,
          userDivison: divison,
          userDistrict: district,
          userArea: area,
          userBloodType: blood,
          admin: admin ?? false);

      final userCreated =
          await DatabaseService.create(userCollection, userID!, user.toJson());
      if (userCreated.isSuccess) {
        return true;
      } else {}
    } else {}
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    await AuthService.logout();
    userID = null;
    removeuser();
    await checkAuthenticationStatus();
    notifyListeners();
  }

  Future<void> checkAuthenticationStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');

    _authenticated = (uid != null);

    notifyListeners();
  }

  Future<void> _token() async {
    String? deviceToken = await authService.getDeviceToken();
    print('token');
    print(deviceToken);
    devicetoken(deviceToken!);
  }

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    try {
      _isLoading = true;
      notifyListeners();

      UserModel currentUser = await getCurrentUser(userID!);

      bool isPasswordValid = await AuthService.validatePassword(
        currentUser.userEmail!,
        currentPassword,
      );

      if (!isPasswordValid) {
        errorMessage = "Current password is incorrect";
        return false;
      }

      // Change the password using AuthService
      final response = await authService.changePassword(
        currentUser.userEmail!,
        currentPassword,
        newPassword,
      );

      if (response.isSuccess) {
        _isLoading = false;
        errorMessage = null;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        errorMessage = response.error?.message ?? "Password change failed";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      errorMessage = "Error changing password: $e";
      notifyListeners();
      return false;
    }
  }


  Future<UserModel> getCurrentUser(String userID) async {
    final response = await DatabaseService.read(
      userCollection,
      userID,
    );

    if (response.isSuccess) {
      return UserModel.fromJson(response.body ?? {});
    } else {
      throw Exception("Error getting current user");
    }
  }
}
