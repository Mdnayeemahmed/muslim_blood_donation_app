import 'package:flutter/material.dart';

class UserList extends StatelessWidget {
  const UserList({
    Key? key,
    this.last = false,
    required this.name,
    required this.area,
    required this.bloodtype,
    required this.number,
    required this.district,
    required this.divison,
    this.onTap,
    this.color,
  });

  final String name, area, district, divison, bloodtype, number;
  final bool last;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
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
                const SizedBox(width: 8),
                Icon(Icons.call),
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
