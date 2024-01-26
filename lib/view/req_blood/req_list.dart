import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:muslim_blood_donor_bd/constant/app_color.dart';
import 'package:muslim_blood_donor_bd/constant/text_style.dart';
import 'package:muslim_blood_donor_bd/view/req_blood/create_req.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/navigation.dart';
import '../../model/req_blood_model.dart';
import '../../view_model/helper/paths.dart';
import '../../widgets/req_blood_widget.dart';

class ReqList extends StatefulWidget {
  const ReqList({Key? key});

  @override
  State<ReqList> createState() => _ReqListState();
}

class _ReqListState extends State<ReqList> {
  late Future<bool> isAdminFuture;

  String path = Paths.database.collectionUser;

  Stream<QuerySnapshot> eventDataStream =
      FirebaseFirestore.instance.collection('req_data_collection').snapshots();

  @override
  void initState() {
    isAdminFuture = getIsAdminFromSharedPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request For Blood'),
      ),

      body: FutureBuilder<bool>(
        future: isAdminFuture,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Text('No data available');
          }

          final bool isAdmin = snapshot.data!;

          return StreamBuilder<QuerySnapshot>(
            stream: eventDataStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text('No data available');
              }

              final currentDate = DateTime.now();

              final filteredData = snapshot.data!.docs
                  .map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final id = doc.id; // Retrieve the document ID
                    data['id'] = id;
                    print(id); // Add the document ID to the data
                    return ReqBloodModel.fromJson(data);
                  })
                  .where((reqBlood) =>
                      reqBlood.reqDateTime != null &&
                      reqBlood.reqDateTime!.isAfter(currentDate))
                  .toList();

              // final filteredData = snapshot.data!.docs
              //     .map((doc) => ReqBloodModel.fromJson(doc.data() as Map<String, dynamic>))
              //     .where((reqBlood) =>
              // reqBlood.reqDateTime != null && reqBlood.reqDateTime!.isAfter(currentDate))
              //     .toList();

              filteredData.sort((a, b) =>
                  (a.reqDateTime != null && b.reqDateTime != null)
                      ? a.reqDateTime!.compareTo(b.reqDateTime!)
                      : 0);

              return ListView.builder(
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  var post = filteredData[index];
                  final reqBlood = filteredData[index];
                  return ReqBloodWidget(
                    isAdmin: isAdmin,
                    bloodtype: reqBlood.patientBloodType ?? "Unknown",
                    pname: reqBlood.patientName ?? "Unknown",
                    preq: reqBlood.patientRequiredBloodBag ?? "Unknown",
                    pcase: reqBlood.patientCaseType ?? "Unknown",
                    phospital: reqBlood.hospital ?? "Unknown",

                    ploction: reqBlood.patientLocation ?? "Unknown",

                    pRContact:
                        reqBlood.patientRelativesContactName ?? "Unknown",
                    pRPhone:
                        reqBlood.patientRelativesContactNumber ?? "Unknown",
                    userName: reqBlood.createUserName ?? "Unknown",
                    userPhone: reqBlood.createUserPhoneNumber ?? "Unknown",
                    date: reqBlood.reqDateTime ?? DateTime(1999),
                    onTapPhone: () {
                      FlutterPhoneDirectCaller.callNumber(
                          reqBlood.patientRelativesContactNumber ??
                              "No Phone Number");
                    },
                    onTap: () {
                      _showDeleteConfirmationDialog(context, post.id);
                      print(post.id);
                    },
                  );
                },
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        onPressed: () {
          Navigation.to(context, const CreateReq());
        },
        label: Text(
          'Add',
          style: TextStyles.style14Bold(Colors.white),
        ),
        icon: const Icon(Icons.add, color: Colors.white, size: 25),
      ),
    );
  }

  Future<bool> getIsAdminFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isAdmin = prefs.getBool('isAdmin') ?? false;
    return isAdmin;
  }

  void _showDeleteConfirmationDialog(BuildContext context, String? id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Confirmation"),
          content: const Text("Are you sure you want to delete this request?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // Call the removeReqBlood method with the documentId
                  await FirebaseFirestore.instance
                      .collection('req_data_collection')
                      .doc(id)
                      .delete();
                  Navigator.of(context).pop(); // Close the dialog
                  _showSnackBar(context, 'Request deleted successfully.');
                } catch (e) {
                  print('Error deleting document: $e');
                  _showSnackBar(context, 'Error deleting request.');
                }
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
