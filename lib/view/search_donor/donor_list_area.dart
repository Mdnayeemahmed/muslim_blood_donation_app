import 'package:flutter/material.dart';
import 'package:muslim_blood_donor_bd/constant/navigation.dart';
import 'package:muslim_blood_donor_bd/view/search_donor/available_blood_list.dart';

import '../../view_model/services/stream_service.dart';
import '../../widgets/list_widget.dart';
import '../dashboard.dart';

class DonorListArea extends StatelessWidget {
  final String divison;

  final String districts;

  const DonorListArea(
      {super.key, required this.divison, required this.districts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Area for $districts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<String>>(
          stream: FirebaseService().getAreaForDistricts(districts, divison),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Loading indicator
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            final areas = snapshot.data ?? [];

            return ListView.builder(
              itemCount: areas.length,
              itemBuilder: (context, index) {
                return ListWidget(
                  title: areas[index],
                  iconData: Icons.arrow_forward,
                  onTap: () {
                    Navigation.to(
                        context,
                        AvailableBloodList(
                            area: areas[index],
                            divison: divison,
                            districts: districts));
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigation.offAll(context, Dashboard());
        },
        label: const Text('Home'),
        icon: const Icon(Icons.home),
      ),

    );
  }
}
