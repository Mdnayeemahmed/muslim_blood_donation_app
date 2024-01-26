import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:muslim_blood_donor_bd/view/dashboard.dart';

import '../../constant/navigation.dart';
import '../../view_model/services/stream_service.dart';
import '../../widgets/user_list.dart';


class DonorUserList extends StatelessWidget {
  final String area;
  final String division;
  final String districts;
  final String bloodtype;

  const DonorUserList({
    Key? key,
    required this.area,
    required this.division,
    required this.districts,
    required this.bloodtype,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Donor For $bloodtype'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: FirebaseService()
            .getUsersForBloodType(bloodtype, area, districts, division),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final userData = snapshot.data ?? [];

          if (userData.isEmpty) {
            return Center(child: Text('No donors available for $bloodtype'));
          }

          return ListView.builder(
            itemCount: userData.length,
            itemBuilder: (context, index) {
              final user = userData[index];
              final name = user['name'];
              final areas = area;
              final district = districts; // Use the 'area' parameter
              final divison = division; // Use the 'area' parameter
              final phone = user['phone'];

              if (name != null && phone != null) {
                return UserList(
                  name: name,
                  area: areas,
                  bloodtype: bloodtype,
                  number: phone,
                  district: district,
                  divison: divison,
                  onTap: () async {
                    {
                      FlutterPhoneDirectCaller.callNumber(phone);
                    }
                  },
                );
              } else {
                return const SizedBox
                    .shrink(); // Return an empty widget if 'name' or 'phone' is null
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigation.off(context, const Dashboard());
        },
        label: const Text('Home'),
        icon: const Icon(Icons.home),
      ),
    );
  }


}
