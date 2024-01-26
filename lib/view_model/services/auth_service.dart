import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../model/response_model/auth_response.dart';
import '../../model/response_model/response_model.dart';

class AuthService {
  static final _authInstance = FirebaseAuth.instance;
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? deviceToken;


  static Future<ResponseModel> login(String email, String password) async {
    try {
      final credential = await _authInstance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userID = credential.user?.uid ?? "";
      return ResponseModel(
        isSuccess: true,
        statusCode: 200,
        body: {"user_id": userID},
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return ResponseModel(
          isSuccess: false,
          statusCode: 400,
          body: {"error_message": 'No user found for that email.'},
        );
      } else if (e.code == 'wrong-password') {
        return ResponseModel(
          isSuccess: false,
          statusCode: 400,
          body: {"error_message": 'Wrong password provided for that user.'},
        );
      } else {
        return ResponseModel(
          isSuccess: false,
          statusCode: 400,
          body: {"error_message": 'An error occurred during login.'},
        );
      }
    } catch (e) {
      return ResponseModel(
        isSuccess: false,
        statusCode: 401,
        body: {"error_message": 'An error occurred during login.'},
      );
    }
  }

  static Future<ResponseModel> createAuth(String email, String password) async {
    try {
      // Create user account
      final credential = await _authInstance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uID = credential.user?.uid ?? "";

      // Sign out the user to prevent automatic login

      // Return response without logging in the user
      return ResponseModel(
        isSuccess: true,
        statusCode: 200,
        body: {"user_id": uID},
      );
    } on FirebaseAuthException catch (e) {
      late String message;
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      }

      return ResponseModel(
        isSuccess: false,
        statusCode: 400,
        body: {"error_message": message},
      );
    } catch (e) {
      return ResponseModel(
        isSuccess: false,
        statusCode: 401,
      );
    }
  }

  static Future<void> logout() async {
    await _authInstance.signOut();
  }

  Future<String?> getDeviceToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    return token;
  }

  Future<AuthResponse> changePassword(String? email, String? currentPassword, String? newPassword) async {
    try {
      if (email == null || currentPassword == null || newPassword == null) {
        return AuthResponse.error("invalid_parameters", "Invalid parameters");
      }

      await _authInstance.signInWithEmailAndPassword(email: email, password: currentPassword);
      await _authInstance.currentUser?.updatePassword(newPassword);
      return AuthResponse.success();
    } on FirebaseAuthException catch (e) {
      return AuthResponse.error(e.code, e.message ?? "An unknown error occurred");
    } catch (e) {
      return AuthResponse.error("unknown_error", e.toString());
    }
  }

  static Future<bool> validatePassword(String email, String password) async {
    return true;
  }

}
