import 'package:cloud_firestore/cloud_firestore.dart';

class ReqBloodModel {
  String? id; // Add the field to store the document ID
  String? patientName;
  String? patientBloodType;
  String? patientRequiredBloodBag;
  String? patientCaseType;
  String? patientLocation;
  String? patientRelativesContactName;
  String? patientRelativesContactNumber;
  String? createUserName;
  String? createUserPhoneNumber;
  DateTime? reqDateTime;
  String? hospital;// Changed the type to DateTime

  ReqBloodModel({
    this.id,
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
    this.hospital
  });

  // Updated the constructor to handle Timestamp
  ReqBloodModel.fromJson(Map<String, dynamic> json) {
    id = json['id']; // Assume 'id' is the field storing the document ID
    createUserName = json['created_user_name'];
    createUserPhoneNumber = json['created_user_phone'];
    patientName = json['patient_name'];
    patientBloodType = json['patient_bloodType'];
    patientCaseType = json['patient_case'];
    patientLocation = json['patient_location'];
    patientRequiredBloodBag = json['patient_required_amount_blood'];
    patientRelativesContactName = json['patient_relative_name'];
    patientRelativesContactNumber = json['patient_relative_phone'];
    hospital = json['hospital'];

    final timestamp = json['req_date_time'] as Timestamp;
    reqDateTime = timestamp.toDate(); // Convert Timestamp to DateTime
  }

  // Updated the toJson method to exclude the 'id' field
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
    data['hospital']=hospital;

    if (reqDateTime != null) {
      data['req_date_time'] = reqDateTime; // Store DateTime directly
    }
    data['patient_case'] = patientCaseType;

    return data;
  }
}
