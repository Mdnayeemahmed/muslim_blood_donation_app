import 'package:flutter/material.dart';

import '../constant/app_color.dart';

class SnackbarUtils {
  static void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: primaryColor, // Replace with your desired color
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
