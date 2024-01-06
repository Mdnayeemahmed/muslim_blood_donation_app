import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constant/text_style.dart';

class ReqBloodWidget extends StatelessWidget {
  final bool isAdmin;
  const ReqBloodWidget({super.key,
    required this.bloodtype,
    required this.pname,
    required this.preq,
    required this.pcase,
    required this.ploction,
    required this.pRContact,
    required this.pRPhone,
    required this.userName,
    required this.date,
    required this.userPhone,
    required this.onTap,
    this.onTapPhone,
    required this.phospital,
    required this.isAdmin,

  });

  final String bloodtype,
      pname,
      preq,
      pcase,
      ploction,
      pRContact,
      pRPhone,
      userName,
  phospital,
      userPhone;
  final DateTime date;
  final VoidCallback? onTap,onTapPhone;


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Blood Type: $bloodtype',
              style: TextStyles.style16Bold(Colors.black)),
          const Divider(),
          Text('Patient: $pname',
              style: TextStyles.style14Bold(Colors.black)),
          Text('Required: $preq Bag',
              style: TextStyles.style14Bold(Colors.black)),
          Text('Case: $pcase', style: TextStyles.style14Bold(Colors.black)),
          Text('Hospital Name: $phospital',
              style: TextStyles.style14Bold(Colors.black)),

          Text('Location: ' + ploction,
              style: TextStyles.style14Bold(Colors.black)),
          Text('Contact: ' + pRContact,
              style: TextStyles.style14Bold(Colors.black)),
          Text('Phone: ' + pRPhone,
              style: TextStyles.style14Bold(Colors.black)),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.date_range),
              SizedBox(width: 5),
              Text(
                  'Date: ' +
                      DateFormat('dd MMM, yyyy hh:mm a')
                          .format(date ?? DateTime(1999)),
                  style: TextStyle(fontSize: 10)),
              SizedBox(width: 5),
              Icon(Icons.people),
              SizedBox(width: 5),
              Text(userName, style: TextStyle(fontSize: 10)),
              SizedBox(width: 5),
              Icon(Icons.call),
              SizedBox(width: 5),
              Text(userPhone, style: TextStyle(fontSize: 10)),
            ],
          ),
          SizedBox(height: 10),
          Container(
            color: Colors.green,
            child: GestureDetector(
              onTap: onTapPhone,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.call, color: Colors.white, size: 20),
                  SizedBox(width: 3),
                  Text('Call',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ],
              ),
            ),
          ),

          if (isAdmin)
            Column(
              children: [
                SizedBox(height: 10),
                Container(
                  color: Colors.red,
                  child: GestureDetector(
                    onTap:onTap,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.delete, color: Colors.white, size: 20),
                        SizedBox(width: 3),
                        Text('Delete',
                            style: TextStyle(fontSize: 16, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }


}


