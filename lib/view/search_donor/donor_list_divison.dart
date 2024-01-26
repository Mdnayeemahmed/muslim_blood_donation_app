import 'package:flutter/material.dart';

import '../../constant/navigation.dart';
import '../../view_model/services/stream_service.dart';
import '../../widgets/list_widget.dart';
import '../dashboard.dart';
import 'donor_list_district.dart';

class DonorListDivison extends StatelessWidget {
  const DonorListDivison({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Division'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<String>>(
          stream: FirebaseService().getDivisionData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Loading indicator
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            final divisions = snapshot.data ?? [];

            return ListView.builder(
              itemCount: divisions.length,
              itemBuilder: (context, index) {
                return ListWidget(
                  title: divisions[index],
                  iconData: Icons.arrow_forward,
                  onTap: () {
                    Navigation.to(context, DonorListDistrict(division: divisions[index]));
                  },
                );
              },
            );
          },
        ),
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
