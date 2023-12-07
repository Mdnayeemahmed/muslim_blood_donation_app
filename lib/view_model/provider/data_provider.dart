import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:muslim_blood_donor_bd/model/data_item.dart';

class DataProvider extends ChangeNotifier {
  List<DataItem> divisions = [];
  List<DataItem> districts = [];
  List<DataItem> area = [];
  DataItem? selectedDivision;
  DataItem? selectedDistrict;
  DataItem? selectedArea;

  Future<void> loadDivisionJsonData() async {
    final String data = await rootBundle.loadString('assets/data/divisions.json');
    final List<dynamic> jsonData = json.decode(data);
    final List<DataItem> dataList =
    jsonData[0]['data'].map<DataItem>((item) => DataItem.fromJson(item)).toList();
    divisions = dataList;
    notifyListeners();
  }

  Future<void> loadDistrictJsonData() async {
    final String data = await rootBundle.loadString('assets/data/districts.json');
    final List<dynamic> jsonData = json.decode(data);
    final List<DataItem> dataList =
    jsonData[0]['data'].map<DataItem>((item) => DataItem.fromJson(item)).toList();
    districts = dataList;
    notifyListeners();
  }

  Future<void> loadUpazilasJsonData() async {
    final String data = await rootBundle.loadString('assets/data/bd-postcodes.json');
    final List<dynamic> jsonData = json.decode(data);
    final List<DataItem> dataList =
    jsonData[0]['data'].map<DataItem>((item) => DataItem.fromJson(item)).toList();
    area = dataList;
    notifyListeners();
  }

}
