// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'dart:convert';
//
// class DataItem {
//   String? id;
//   String? name;
//   String? postOffice;
//
//   String? division_id;
//   String? district_id;
//
//
//   DataItem({this.id, this.name,this.division_id,this.district_id,this.postOffice});
//
//   DataItem.fromJson(Map<String, dynamic> json) {
//     id = json['id']??'';
//     name = json['name']??'';
//     division_id = json['division_id']??'';
//     district_id = json['district_id']??'';
//     postOffice = json['postOffice']??'';
//   }
//
//   String toString() {
//     return 'Data(id: $id, name: $name,division_id:$division_id,district_id:$district_id)';
//   }
// }
//
//
//
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   List<DataItem> divisions = [];
//   List<DataItem> districts = [];
//   List<DataItem> upazilas = [];
//
//   DataItem? selectedDivision;
//   DataItem? selectedDistrict;
//   DataItem? selectedupazilas;
//
//
//   @override
//   void initState() {
//     super.initStatete();
//     loadDivisionJsonData(); // Load division data
//     loadDistrictJsonData();
//     loadupzilasJsonData();// Load district data
//   }
//
//   Future<void> loadDivisionJsonData() async {
//     final String data = await rootBundle.loadString('assets/data/divisions.json');
//     final List<dynamic> jsonData = json.decode(data);
//     final List<DataItem> dataList =
//     jsonData[0]['data'].map<DataItem>((item) => DataItem.fromJson(item)).toList();
//     setState(() {
//       divisions = dataList;
//     });
//   }
//
//   Future<void> loadDistrictJsonData() async {
//     final String data = await rootBundle.loadString('assets/data/districts.json');
//     final List<dynamic> jsonData = json.decode(data);
//     final List<DataItem> dataList =
//     jsonData[0]['data'].map<DataItem>((item) => DataItem.fromJson(item)).toList();
//     setState(() {
//       districts = dataList;
//     });
//   }
//
//   Future<void> loadupzilasJsonData() async {
//     final String data = await rootBundle.loadString('assets/data/bd-postcodes.json');
//     print(data);
//     final List<dynamic> jsonData = json.decode(data);
//     print(jsonData);
//     final List<DataItem> dataList =
//     jsonData[0]['data'].map<DataItem>((item) => DataItem.fromJson(item)).toList();
//     print(dataList);
//     setState(() {
//       upazilas = dataList;
//       print('xyz');
//       print(upazilas);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Dropdown Menu Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             DropdownButton<DataItem>(
//               value: selectedDivision,
//               items: divisions.map((DataItem item) {
//                 return DropdownMenuItem<DataItem>(
//                   value: item,
//                   child: Text(item.name ?? "No Name"),
//                 );
//               }).toList(),
//               onChanged: (DataItem? newValue) {
//                 setState(() {
//                   selectedDivision = newValue;
//                   // Clear the selected district when changing division
//                   selectedDistrict = null;
//                 });
//               },
//             ),
//             SizedBox(height: 20),
//             if (selectedDivision != null && districts.isNotEmpty)
//               DropdownButton<DataItem>(
//                 value: selectedDistrict,
//                 items: districts
//                     .where((district) => district.division_id == selectedDivision!.id)
//                     .map((DataItem item) {
//                   return DropdownMenuItem<DataItem>(
//                     value: item,
//                     child: Text(item.name ?? "No Name"),
//                   );
//                 })
//                     .toList(),
//                 onChanged: (DataItem? newValue) {
//                   setState(() {
//                     selectedDistrict = newValue;
//                   });
//                 },
//               ),
//             SizedBox(height: 20),
//             if (selectedDivision != null && selectedDistrict != null && upazilas.isNotEmpty)
//               DropdownButton<DataItem>(
//                 value: selectedupazilas,
//                 items: upazilas
//                     .where((upazilas) => upazilas.district_id == selectedDistrict!.id)
//                     .map((DataItem item) {
//                   return DropdownMenuItem<DataItem>(
//                     value: item,
//                     child: Text(item.postOffice ?? "No Name"),
//                   );
//                 })
//                     .toList(),
//                 onChanged: (DataItem? newValue) {
//                   setState(() {
//                     selectedupazilas = newValue;
//                   });
//                 },
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
