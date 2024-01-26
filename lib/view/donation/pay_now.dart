import 'package:flutter/material.dart';
import 'package:muslim_blood_donor_bd/constant/navigation.dart';

import '../../constant/assets_path.dart';
import '../../view_model/provider/edit_donate_provider.dart';
import '../../widgets/common_button_style.dart';
import '../../widgets/web_view.dart';

class PayNow extends StatelessWidget {
  const PayNow({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width * 0.6;

    return Scaffold(
      appBar: AppBar(
        title: Text('Donate Us'),
        leading: BackButton(
          onPressed: (){
            Navigation.back(context);
          }
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AssetsPath.Bkashlogo,
                width: screenWidth,
              ),
              SizedBox(
                height: 2,
              ),
              CommonButtonStyle(
                title: 'Donate Us',
                onTap: () async {
                  final docID =
                      'payment_Donate'; // Replace with your actual docID
                  String? linkUrl; // Declare linkUrl here

                  await EditDonateProvider().fetchData(docID).then((donate) {
                    if (donate != null) {
                      // Set the data in the controllers
                      linkUrl = donate.link ?? '';
                    }
                  });

                  // Check if linkUrl is not null and not empty before navigating
                  if (linkUrl != null && linkUrl!.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebViewScreen(
                          title: 'Donate Us',
                          linkUrl: linkUrl,
                        ),
                      ),
                    );
                  } else {
                    // Handle the case where linkUrl is null or empty
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Invalid link URL"),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
