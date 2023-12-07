import 'package:flutter/material.dart';
import 'package:muslim_blood_donor_bd/constant/text_style.dart';



class CommonButtonStyle extends StatelessWidget {
  const CommonButtonStyle({
    super.key,
    required this.title,
    required this.onTap,
  });

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: onTap,
            child: Text(
              title,
              style: TextStyles.style16Bold(Colors.white),
            )));
  }
}
