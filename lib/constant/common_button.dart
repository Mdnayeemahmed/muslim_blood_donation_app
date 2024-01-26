import 'package:flutter/material.dart';
import 'package:muslim_blood_donor_bd/constant/app_color.dart';
import 'package:muslim_blood_donor_bd/constant/text_style.dart';


class CommonButton extends StatelessWidget {
  const CommonButton(
      {super.key,
      required this.ontap,
      required this.title, required this.iconData});

  final VoidCallback ontap;
  final String title;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: ontap,
          child: Container(
            height: 60.0,
            width: 60.0,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              color: primaryColor,
            ),
            child: Icon(
              iconData,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Center(
          child: Text(
            title,
            style: TextStyles.style14Bold(dark),
            textAlign: TextAlign.center, // Ensure the text is centered
          ),
        ),
      ],
    );
  }
}
