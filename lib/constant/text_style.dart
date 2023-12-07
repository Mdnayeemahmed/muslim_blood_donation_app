import 'package:flutter/material.dart';

class TextStyles {
  static TextStyle headlineStyle(Color color) => TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: color,
  );

  static TextStyle style16(Color color) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: color,
  );
  static TextStyle style16Bold(Color color) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: color,
  );
  static TextStyle subheadlineStyle(Color color) => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: color,
  );

  static TextStyle style16BoldBangla(Color color) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: 'hind',
    color: color,
  );
  static TextStyle style14Bold(Color color) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: color,
  );
}