import 'package:flutter/material.dart';

class ApproveUser extends StatelessWidget {
  const ApproveUser({
    Key? key,
    this.last = false,
    required this.name,
    required this.area,
    required this.bloodtype,
    required this.number,
    required this.district,
    required this.divison,
    this.onCheckTap,
    this.onCloseTap,
    this.color,
  });

  final String name, area, district, divison, bloodtype, number;
  final bool last;
  final VoidCallback? onCheckTap;
  final VoidCallback? onCloseTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          // You can provide a global onTap function here if needed.
          // For specific icons, use onCheckTap and onCloseTap callbacks.
        },
        child: Column(
          // Use Column instead of ListView
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.people),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name),
                      Row(
                        children: [
                          Text(area),
                          SizedBox(
                            width: 1,
                          ),
                          Text(district),
                          SizedBox(
                            width: 1,
                          ),
                          Text(divison)
                        ],
                      ),
                      Text('Blood Type: ' + bloodtype),
                      Text(number),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: onCheckTap,
                  child: Icon(Icons.check),
                ),
                const SizedBox(width: 16),
                last
                    ? const SizedBox.shrink()
                    : const Divider(
                  color: Colors.black12,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
