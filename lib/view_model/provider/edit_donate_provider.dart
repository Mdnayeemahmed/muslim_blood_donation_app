import 'package:flutter/cupertino.dart';
import 'package:muslim_blood_donor_bd/model/create_donate.dart';
import 'package:muslim_blood_donor_bd/view_model/services/database_service.dart';

import '../helper/paths.dart';

class EditDonateProvider extends ChangeNotifier {
  final database = DatabaseService();
  bool _isLoading = false;
  String editDonate = Paths.database.collectionDonation;

  static const String docID = "payment_Donate"; // Set docID to "blood_Donate"

  bool get isLoading => _isLoading;

  Future<bool> submit(String title, String link,) async {
    Donate donate = Donate(
      title: title,
      link: link,
    );

    final response =
    await DatabaseService.create(editDonate, docID, donate.toJson());
    _isLoading = false;
    notifyListeners();

    if (response.isSuccess) {
      return true;
    } else {
      return false;
    }

    // Note: The code below will never be reached, as the function already returns true or false based on response.isSuccess
    // return true;
  }

  Future<Donate?> fetchData(String docID) async {
    final response = await DatabaseService.read(editDonate, docID);
    if (response.isSuccess) {
      final data = response.body;
      if (data != null) {
        return Donate.fromJson(data);
      }
    }
    return null;
  }
}
