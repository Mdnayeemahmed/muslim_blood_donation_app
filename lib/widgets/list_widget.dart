import 'package:flutter/material.dart';

import '../constant/app_color.dart';
import '../constant/text_style.dart';

class ListWidget extends StatelessWidget {
  const ListWidget({
    super.key,
    this.last = false,
    required this.title,
    required this.iconData, // Add iconData parameter
    this.onTap,
    this.color
  });

  final String title;
  final IconData iconData; // Define the IconData parameter
  final bool last;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            children: [
              Icon(iconData,color: color,), // Use the provided iconData
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.style16Bold(dark),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios_outlined)
            ],
          ),
          last
              ? const SizedBox.shrink()
              : const Divider(
                  color: Colors.black12,
                ),
        ],
      ),
    );
  }
}
