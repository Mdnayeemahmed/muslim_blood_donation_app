import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:muslim_blood_donor_bd/constant/app_color.dart';
import 'package:muslim_blood_donor_bd/constant/text_style.dart';
import 'package:muslim_blood_donor_bd/view/req_blood/create_req.dart';

import '../../constant/navigation.dart';
import '../../model/req_blood_model.dart';
import '../../widgets/req_blood_widget.dart';

class ReqList extends StatefulWidget {
  const ReqList({Key? key});

  @override
  State<ReqList> createState() => _ReqListState();
}

class _ReqListState extends State<ReqList> {
  Stream<QuerySnapshot> eventDataStream =
  FirebaseFirestore.instance.collection('req_data_collection').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request For Blood'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: eventDataStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // While data is loading
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('No data available'); // Handle no data case
          }

          final currentDate = DateTime.now();

          final filteredData = snapshot.data!.docs
              .map((doc) => ReqBloodModel.fromJson(doc.data() as Map<String, dynamic>))
              .where((reqBlood) => reqBlood.reqDateTime != null && reqBlood.reqDateTime!.isAfter(currentDate))
              .toList();

          filteredData.sort((a, b) => (a.reqDateTime != null && b.reqDateTime != null)
              ? a.reqDateTime!.compareTo(b.reqDateTime!)
              : 0);

          return ListView.builder(
            itemCount: filteredData.length,
            itemBuilder: (context, index) {
              final reqBlood = filteredData[index];
              return ReqBloodWidget(
                bloodtype: reqBlood.patientBloodType ?? "Unknown",
                pname: reqBlood.patientName ?? "Unknown",
                preq: reqBlood.patientRequiredBloodBag ?? "Unknown",
                pcase: reqBlood.patientCaseType ?? "Unknown",
                ploction: reqBlood.patientLocation ?? "Unknown",
                pRContact: reqBlood.patientRelativesContactName ?? "Unknown",
                pRPhone: reqBlood.patientRelativesContactNumber ?? "Unknown",
                userName: reqBlood.createUserName ?? "Unknown",
                userPhone: reqBlood.createUserPhoneNumber ?? "Unknown",
                date: reqBlood.reqDateTime ?? DateTime(1999),
                onTap: () {
                  FlutterPhoneDirectCaller.callNumber(
                      reqBlood.patientRelativesContactNumber ?? "No Phone Number");
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        onPressed: () {
          Navigation.to(context, CreateReq());
        },
        label: Text(
          'Add',
          style: TextStyles.style14Bold(Colors.white),
        ),
        icon: const Icon(Icons.add, color: Colors.white, size: 25),
      ),
    );
  }
}
