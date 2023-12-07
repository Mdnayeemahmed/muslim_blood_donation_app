import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/response_model/response_model.dart';

class DatabaseService {
  static final _dbInstance = FirebaseFirestore.instance;

  static Future<ResponseModel> create(
    String collection,
    String docID,
    Map<String, dynamic> json,
  ) async {
    try {
      await _dbInstance.collection(collection).doc(docID).set(json);
      return ResponseModel(
        isSuccess: true,
        statusCode: 200,
      );
    } catch (e) {
      return ResponseModel(
        isSuccess: false,
        statusCode: 401,
      );
    }
  }

  static Future<ResponseModel> read(
    String collection,
    String docID,
  ) async {
    try {
      var json = await _dbInstance.collection(collection).doc(docID).get();
      return ResponseModel(
        isSuccess: true,
        statusCode: 200,
        body: json.data(),
      );
    } catch (e) {
      return ResponseModel(
        isSuccess: false,
        statusCode: 401,
      );
    }
  }

  static Future<ResponseModel> update(
    String collection,
    String docID,
    Map<String, dynamic> json,
  ) async {
    try {
      await _dbInstance.collection(collection).doc(docID).update(json);
      return ResponseModel(
        isSuccess: true,
        statusCode: 200,
      );
    } catch (e) {
      return ResponseModel(
        isSuccess: false,
        statusCode: 401,
      );
    }
  }

  static Future<ResponseModel> delete(
    String collection,
    String docID,
  ) async {
    try {
      await _dbInstance.collection(collection).doc(docID).delete();
      return ResponseModel(
        isSuccess: true,
        statusCode: 200,
      );
    } catch (e) {
      return ResponseModel(
        isSuccess: false,
        statusCode: 401,
      );
    }
  }
}
