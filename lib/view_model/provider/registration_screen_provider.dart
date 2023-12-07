import 'package:flutter/material.dart';
import 'package:muslim_blood_donor_bd/model/data_item.dart';

class SelectionModel extends ChangeNotifier {
  DataItem? selectedDivision;
  DataItem? selectedDistrict;
  DataItem? selectedArea;
  String? selectedBloodGroup;


  void setDivision(DataItem division) {
    selectedDivision = division;
    print(selectedDivision);
    selectedDistrict = null;
    selectedArea = null;
    notifyListeners();
  }

  void setDistrict(DataItem district) {
    selectedDistrict = district;
    print(selectedDistrict);

    selectedArea = null;
    notifyListeners();
  }

  void setUpazila(DataItem upazila) {
    selectedArea = upazila;

    notifyListeners();
  }

  void setBloodGroup(String bloodGroup) {
    selectedBloodGroup = bloodGroup; // Set the selected Blood Group
    notifyListeners();
  }
  void reset() {
    selectedDivision = null;
    selectedDistrict = null;
    selectedArea = null;
    selectedBloodGroup = null;
    notifyListeners();
  }


}
