import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateUtilsfunction {
  static Future<void> pickDate(BuildContext context, bool isDateOfBirth, TextEditingController dateController, Function(DateTime) updateProfileFunction) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: isDateOfBirth ? DateTime(1970) : DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      final formattedDate = DateFormat('dd MMM yyyy').format(picked);
      dateController.text = formattedDate;
      updateProfileFunction(picked);
    }
  }
}
