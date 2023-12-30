import 'package:flutter/material.dart';

import '../../constant/navigation.dart';
import '../../view_model/services/stream_service.dart';
import '../../widgets/list_widget.dart';
import '../dashboard.dart';
import 'donor_user_list.dart';

class AvailableBloodList extends StatelessWidget {
  final String area;
  final String divison;

  final String districts;

  const AvailableBloodList(
      {super.key,
      required this.area,
      required this.divison,
      required this.districts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available blood in $area'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<String>>(
          stream: FirebaseService().getBloodForArea(area, districts, divison),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Loading indicator
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            final bloodtypes = snapshot.data ?? [];

            return ListView.builder(
              itemCount: bloodtypes.length,
              itemBuilder: (context, index) {
                return ListWidget(
                  title: bloodtypes[index],
                  iconData: Icons.water_drop,color: Colors.red,
                  onTap: () {
                    Navigation.to(context,DonorUserList(area: area, districts: districts, bloodtype: bloodtypes[index], division: divison,));

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
