import 'package:cloud_firestore/cloud_firestore.dart';

class ReqBloodModel {
  String? patientName;
  String? patientBloodType;
  String? patientRequiredBloodBag;
  String? patientCaseType;
  String? patientLocation;
  String? patientRelativesContactName;
  String? patientRelativesContactNumber;
  String? createUserName;
  String? createUserPhoneNumber;
  DateTime? reqDateTime; // Changed the type to DateTime

  ReqBloodModel({
    this.createUserName,
    this.createUserPhoneNumber,
    this.patientCaseType,
    this.patientName,
    this.patientBloodType,
    this.patientLocation,
    this.patientRequiredBloodBag,
    this.patientRelativesContactName,
    this.patientRelativesContactNumber,
    this.reqDateTime,
  });

  // Updated the constructor to handle Timestamp
  ReqBloodModel.fromJson(Map<String, dynamic> json) {
    createUserName = json['created_user_name'];
    createUserPhoneNumber = json['created_user_phone'];
    patientName = json['patient_name'];
    patientBloodType = json['patient_bloodType'];
    patientCaseType = json['patient_case'];
    patientLocation = json['patient_location'];
    patientRequiredBloodBag = json['patient_required_amount_blood'];
    patientRelativesContactName = json['patient_relative_name'];
    patientRelativesContactNumber = json['patient_relative_phone'];
    final timestamp = json['req_date_time'] as Timestamp;
    reqDateTime = timestamp.toDate(); // Convert Timestamp to DateTime
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created_user_name'] = createUserName;
    data['created_user_phone'] = createUserPhoneNumber;
    data['patient_name'] = patientName;
    data['patient_bloodType'] = patientBloodType;
    data['patient_location'] = patientLocation;
    data['patient_required_amount_blood'] = patientRequiredBloodBag;
    data['patient_relative_name'] = patientRelativesContactName;
    data['patient_relative_phone'] = patientRelativesContactNumber;
    if (reqDateTime != null) {
      data['req_date_time'] = reqDateTime; // Store DateTime directly
    }
    data['patient_case'] = patientCaseType;
    return data;
  }
}
