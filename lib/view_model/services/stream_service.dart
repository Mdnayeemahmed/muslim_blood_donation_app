import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<String>> getDivisionData() {
    return _firestore
        .collection('user_data_collection')
        .snapshots()
        .map((snapshot) {
      final divisions = <String>{};
      for (var doc in snapshot.docs) {
        final division =
            doc['user_divison']; // Replace 'division' with the actual field name
        divisions.add(division);
      }
      return divisions.toList();
    });

  }
  Stream<List<String>> getDistrictsForDivision(String division) {
    return _firestore
        .collection('user_data_collection')
        .where('user_divison', isEqualTo: division)
        .snapshots()
        .map((snapshot) {
      final districts = <String>{};
      for (var doc in snapshot.docs) {
        final district = doc['user_district']; // Replace 'district' with the actual field name
        districts.add(district);
      }
      return districts.toList();
    });
  }
  Stream<List<String>> getAreaForDistricts(String district, String division) {
    return _firestore
        .collection('user_data_collection')
        .where('user_district', isEqualTo: district)
        .where('user_divison', isEqualTo: division)
        .snapshots()
        .map((snapshot) {
      final areas = <String>{};
      for (var doc in snapshot.docs) {
        final area = doc['user_area']; // Replace with the actual field name
        areas.add(area);
      }
      return areas.toList();
    });
  }

  Stream<List<String>> getBloodForArea(String area,String district, String division) {
    return _firestore
        .collection('user_data_collection')
        .where('user_area', isEqualTo: area)
        .where('user_district', isEqualTo: district)
        .where('user_divison', isEqualTo: division)
        .snapshots()
        .map((snapshot) {
      final bloodtype = <String>{};
      for (var doc in snapshot.docs) {
        final blood = doc['user_bloodtype']; // Replace with the actual field name
        bloodtype.add(blood);
      }
      return bloodtype.toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getUsersForBloodType(String bloodType, String area, String district, String division) {
    return _firestore
        .collection('user_data_collection')
        .where('user_bloodtype', isEqualTo: bloodType)
        .where('user_area', isEqualTo: area)
        .where('user_district', isEqualTo: district)
        .where('user_divison', isEqualTo: division)
        .snapshots()
        .map((snapshot) {
      final usersData = <Map<String, dynamic>>[];
      for (var doc in snapshot.docs) {
        final userName = doc['user_name'] as String; // Ensure type is String
        final userPhone = doc['user_phone'] as String; // Ensure type is String

        final userData = {
          'name': userName,
          'phone': userPhone,
        };
        usersData.add(userData);
      }
      return usersData;
    });
  }
}
