import 'package:flutter/material.dart';

class Navigation {
  static to(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static off(BuildContext context, Widget page) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static offAll(BuildContext context, Widget page) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => page),
          (Route<dynamic> route) => false,
    );
  }

  static back(BuildContext context) {
    Navigator.of(context).pop();
  }
}