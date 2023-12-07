import 'package:flutter/material.dart';

class CommonPassTextField extends StatelessWidget {
  const CommonPassTextField({
    super.key,
    required this.controller,
    required this.validator,
    required this.hinttext,
    this.textInputType,
  });

  final TextEditingController controller;
  final Function(String?) validator;
  final String hinttext;
  final TextInputType? textInputType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) => validator(value),
      keyboardType: textInputType,
      obscureText: true,
      decoration: InputDecoration(
        hintText: hinttext,
      ),
    );
  }
}
