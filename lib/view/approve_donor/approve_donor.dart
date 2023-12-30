import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/user_model.dart';
import '../../view_model/services/database_service.dart';
import '../../widgets/approve_user.dart';

class ApproveDonor extends StatefulWidget {
  const ApproveDonor({Key? key}) : super(key: key);

  @override
  State<ApproveDonor> createState() => _ApproveDonorState();
}

class _ApproveDonorState extends State<ApproveDonor> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approve User'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user_data_collection')
            .where('approve_status', isEqualTo: false)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<DocumentSnapshot> documents = snapshot.data!.docs;
            List<UserModel> users = documents.map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>)).toList();

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                UserModel user = users[index];
                return ApproveUser(
                  name: user.userName ?? '',
                  area: user.userArea ?? '',
                  bloodtype: user.userBloodType ?? '',
                  number: user.userPhone ?? '',
                  district: user.userDistrict ?? '',
                  divison: user.userDivison ?? '',
                  onCheckTap: () async {
                    // Handle check icon tap
                    await updateApproveStatus(user.userId.toString());
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<void> updateApproveStatus(String userId) async {
    final Map<String, dynamic> updateData = {'approve_status': true};
    final response = await DatabaseService.update('user_data_collection', userId, updateData);

    if (response.isSuccess) {
      _showSnackBar(context, 'Approved');
    }else {
      _showSnackBar(context, 'Something went Wrong!');
    }
    }
  }


  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
}


