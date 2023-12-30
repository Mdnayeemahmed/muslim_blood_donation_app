import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../model/req_blood_model.dart';
import '../../model/response_model/response_model.dart';
import '../helper/paths.dart';
import '../services/database_service.dart';

class CreateReqProvider extends ChangeNotifier {
  final DatabaseService databaseService = DatabaseService();
  var uuid = const Uuid();

  bool _isLoading = false;
  String reqCollection = Paths.database.collectionReq;
  String userCollection = Paths.database.collectionUser;


  bool get isLoading => _isLoading;

  Future<Map<String, String>> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    if (uid == null) {
      print('User UID not found in shared preferences');
      return {};
    }

    ResponseModel userSnapshot = await DatabaseService.read(userCollection, uid);

    if (userSnapshot.isSuccess) {
      String? name = userSnapshot.body?['user_name'];
      String? number = userSnapshot.body?['user_phone'];

      if (name != null && number != null) {


        return {'name': name, 'number': number};
      }
    }

    return {};
  }

  Future<bool> reqBlood(
      DateTime requestDateTime,
      String pName,
      String pBloodType,
      String pBloodAmount,
      String pLocation,
      String pRName,
      String pRNumber,
      String pCase,
      String hospital
      ) async {
    final userInfo = await getUserInfo();
    String cName = userInfo['name'] ?? ''; // Default to an empty string if not found
    String cNumber = userInfo['number'] ?? ''; // Default to an empty string if not found

    if (cName.isEmpty || cNumber.isEmpty) {
      return false;
    }

    _isLoading = true;
    notifyListeners();
    final docID = uuid.v4();

    ReqBloodModel req = ReqBloodModel(
      createUserName: cName,
      createUserPhoneNumber: cNumber,
      patientName: pName,
      patientBloodType: pBloodType,
      patientRequiredBloodBag: pBloodAmount,
      patientCaseType:pCase,
      patientLocation: pLocation,
      reqDateTime: requestDateTime,
      patientRelativesContactName: pRName,
      patientRelativesContactNumber: pRNumber,
      hospital: hospital,
    );

    final response = await DatabaseService.create(reqCollection, docID, req.toJson());
    _isLoading = false;
    notifyListeners();

    if (response.isSuccess) {
      return true;
    } else {
      return false;
    }
  }


}
