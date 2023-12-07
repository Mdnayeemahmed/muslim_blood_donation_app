import 'package:flutter/material.dart';


class CommonTextField extends StatelessWidget {
  const CommonTextField({
    super.key,
    this.controller,
    required this.validator,
    required this.hinttext,
    this.textInputType,
    this.maxline, // Add selectedOption parameter
  });

  final TextEditingController? controller;
  final Function(String?) validator;
  final String hinttext;
  final TextInputType? textInputType;
  final int? maxline;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) => validator(value),
      keyboardType: textInputType,
      maxLines: maxline,
      decoration: InputDecoration(
        hintText: hinttext,
      ),

    );
  }
}
