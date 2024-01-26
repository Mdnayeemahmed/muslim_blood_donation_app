import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:muslim_blood_donor_bd/constant/navigation.dart';
import 'package:muslim_blood_donor_bd/model/signup_model.dart';
import 'package:muslim_blood_donor_bd/view/authentication/login.dart';
import 'package:muslim_blood_donor_bd/view/splash_screen.dart';
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

  String? _userName; // New field to store user_name

  String get userName => _userName ?? ''; // Getter for user_name
  bool _authenticated = false;

  bool get isLoading => _isLoading;

  bool get isAuthenticated => _authenticated;

  final UserModel _currentUser = UserModel();

  UserModel get currentUser => _currentUser;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final response = await AuthService.login(email, password);
    _isLoading = false;
    notifyListeners();

    if (response.isSuccess) {
      userID = response.body?["user_id"];

      Map<String, dynamic>? userInfo = await getUserInfo(userID!);

      if (userInfo?['userName'] != null) {
        writeUid(userID!);
        _userName = userInfo?['userName'];
        writeUserName(_userName!);
        bool isAdmin = userInfo?['admin'] ?? false;
        writeAdminStatus(isAdmin);
        await checkAndUpdateDeviceToken(userID!);
        // await getCurrentUser(userID!);
        notifyListeners();
        return true;
      } else {

        notifyListeners();
        return false;
      }
    }
      return false;

  }

  Future<bool> signUp(String email, password, String name, String phone,
      String divison, String district, String area, String blood,String dateofbirth,String reference,String sociallink,String conditon,
      {bool? admin, bool? approve_status}) async {
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
          admin: admin ?? false,
          dateofbirth: dateofbirth,
          counter: '0',
          condition: conditon,
          socialMediaLink: sociallink,
          reference: reference,
          isAvailable: true,
          approve_status: approve_status ?? false);

      final userCreated =
          await DatabaseService.create(userCollection, userID!, user.toJson());
      if (userCreated.isSuccess) {
        return true;
      } else {}
    } else {}
    notifyListeners();
    return false;
  }

  Future<void> logout(BuildContext context) async {
    await AuthService.logout();
    userID = null;
    removeuser();
    await checkAuthenticationStatus();
    clearUserName();
    notifyListeners();

    Navigation.offAll(context, const SplashScreen());
  }

  Future<void> checkAuthenticationStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    _userName = prefs.getString('user_name');

    _authenticated = (uid != null);

    notifyListeners();
  }

  Future<void> _token() async {
    String? deviceToken = await authService.getDeviceToken();
    devicetoken(deviceToken!);
  }

  Future<bool> changePassword(
      String currentPassword, String newPassword) async {
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

  Future<bool> adminSignUp(String email, password, String name, String phone,
      String divison, String district, String area, String blood,String dateofbirth,String reference,String sociallink,String conditon,
      {bool? admin, bool? approve_status}) async {
    _isLoading = true;
    notifyListeners();

    final response = await AuthService.createAuth(email, password);

    _isLoading = false;

    if (response.isSuccess) {
      userID = response.body?["user_id"] as String;
      final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      String formattedCreatedTime = formatter.format(DateTime.now());
      String formattedLastUpdateTime = formatter.format(DateTime.now());

      SignUpModel user = SignUpModel(
          userId: userID,
          userEmail: email,
          userName: name,
          userDeviceTokens: '',
          createdTime: formattedCreatedTime,
          lastUpdateTime: formattedLastUpdateTime,
          userPhone: phone,
          userDivison: divison,
          userDistrict: district,
          userArea: area,
          userBloodType: blood,
          dateofbirth: dateofbirth,
          counter: '0',
          condition: conditon,
          socialMediaLink: sociallink,
          reference: reference,
          isAvailable: true,
          admin: admin ?? true,
          approve_status: approve_status ?? true);

      final userCreated =
          await DatabaseService.create(userCollection, userID!, user.toJson());
      if (userCreated.isSuccess) {
        return true;
      } else {}
    } else {}
    notifyListeners();
    return false;
  }

  Future<bool> userSignUpByAdmin(String email, password, String name,
      String phone, String divison, String district, String area, String blood,String dateofbirth,String reference,String sociallink,String conditon,
      {bool? admin, bool? approve_status}) async {
    _isLoading = true;
    notifyListeners();

    final response = await AuthService.createAuth(email, password);

    _isLoading = false;

    if (response.isSuccess) {
      userID = response.body?["user_id"] as String;
      final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      String formattedCreatedTime = formatter.format(DateTime.now());
      String formattedLastUpdateTime = formatter.format(DateTime.now());

      SignUpModel user = SignUpModel(
          userId: userID,
          userEmail: email,
          userName: name,
          userDeviceTokens: '',
          createdTime: formattedCreatedTime,
          lastUpdateTime: formattedLastUpdateTime,
          userPhone: phone,
          userDivison: divison,
          userDistrict: district,
          userArea: area,
          userBloodType: blood,
          dateofbirth: dateofbirth,
          counter: '0',
          condition: conditon,
          socialMediaLink: sociallink,
          reference: reference,
          isAvailable: true,
          admin: admin ?? false,
          approve_status: approve_status ?? true);

      final userCreated =
          await DatabaseService.create(userCollection, userID!, user.toJson());
      if (userCreated.isSuccess) {
        return true;
      } else {}
    } else {}
    notifyListeners();
    return false;
  }

  Future<Map<String, dynamic>?> getUserInfo(String userID) async {
    try {
      UserModel currentUser = await getCurrentUser(userID);
      return {
        'userID': currentUser.userId,
        'userName': currentUser.userName,
        'admin': currentUser.admin ?? false,
      };
    } catch (e) {
      // Handle error, e.g., user not found
      return null; // or return a default value or handle it accordingly
    }
  }

  Future<void> writeAdminStatus(bool isAdmin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAdmin', isAdmin);
  }

  Future<void> checkAndUpdateDeviceToken(String userID) async {
    String? currentDeviceToken = await authService.getDeviceToken();

    UserModel currentUser = await getCurrentUser(userID);

    if (currentUser.userDeviceTokens != currentDeviceToken) {
      // Device token is different, update it in the user collection
      currentUser.userDeviceTokens = currentDeviceToken;
      await DatabaseService.update(
          userCollection, userID, currentUser.toJson());
    }
  }

  Future<void> writeUserName(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', userName);
  }

  Future<void> clearUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_name');
  }
}
