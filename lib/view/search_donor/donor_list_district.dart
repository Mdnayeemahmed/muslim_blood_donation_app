import 'package:flutter/material.dart';
import 'package:muslim_blood_donor_bd/view/search_donor/donor_list_area.dart';

import '../../constant/navigation.dart';
import '../../view_model/services/stream_service.dart';
import '../../widgets/list_widget.dart';
import '../dashboard.dart';

class DonorListDistrict extends StatelessWidget {
  final String division;

  const DonorListDistrict({super.key, required this.division});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select District for $division'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<String>>(
          stream: FirebaseService().getDistrictsForDivision(division),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Loading indicator
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            final districts = snapshot.data ?? [];

            return ListView.builder(
              itemCount: districts.length,
              itemBuilder: (context, index) {
                return ListWidget(
                  title: districts[index],
                  iconData: Icons.arrow_forward,
                  onTap: () {
                    Navigation.to(context, DonorListArea(divison: division,districts: districts[index]));

                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigation.offAll(context, const Dashboard());
        },
        label: const Text('Home'),
        icon: const Icon(Icons.home),
      ),

    );
  }
}
