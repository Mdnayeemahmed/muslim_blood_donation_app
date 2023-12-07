import 'package:flutter/material.dart';
import 'package:muslim_blood_donor_bd/constant/common_button.dart';
import 'package:muslim_blood_donor_bd/view/profile/current_profile_page.dart';
import 'package:muslim_blood_donor_bd/view/profile/profile.dart';
import 'package:muslim_blood_donor_bd/view/req_blood/req_list.dart';
import 'package:muslim_blood_donor_bd/view/search_donor/donor_list_divison.dart';
import 'package:muslim_blood_donor_bd/view/req_blood/create_req.dart';

import '../constant/navigation.dart';
import '../model/user_model.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                width: screenWidth,
                child: Image.network(
                  "https://t3.ftcdn.net/jpg/02/76/71/88/360_F_276718846_1mDkxI8gb6FrfuwAiPb6OuB4M7BbeuoV.jpg",
                  // Replace with your image path
                  fit: BoxFit
                      .fitWidth, // You can use BoxFit.contain or other options based on your needs
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 2.0, // Adjust as needed
                    crossAxisSpacing: 2.0, // Adjust as needed
                    children: [
                      CommonButton(
                        ontap: () {
                          Navigation.to(context, DonorListDivison());
                        },
                        title: 'Donor List',
                        iconData: Icons.list,
                      ),
                      CommonButton(
                        ontap: () {
                          Navigation.to(context, ReqList());

                        },
                        title: 'Blood Request',
                        iconData: Icons.bloodtype,
                      ),
                      CommonButton(
                          ontap: () {
                            print(UserModel());
                            Navigation.to(context, CurrentProfilePage());
                          },
                          title: 'Be A Donor',

                          iconData: Icons.handshake_outlined),
                      CommonButton(
                        ontap: () {},
                        title: 'Feed',
                        iconData: Icons.newspaper,
                      ),
                      CommonButton(
                        ontap: () {},
                        title: 'Donate Us',
                        iconData: Icons.monetization_on_outlined,
                      ),
                      CommonButton(
                        ontap: () {},
                        title: 'About Us',
                        iconData: Icons.info_outline,
                      ),
                      CommonButton(
                        ontap: () {
                          Navigation.to(context, DonorListDivison());
                        },
                        title: 'Register User',
                        iconData: Icons.list,
                      ),
                      CommonButton(
                        ontap: () {
                          Navigation.to(context, DonorListDivison());
                        },
                        title: 'Edit Donate',
                        iconData: Icons.list,
                      ),
                      CommonButton(
                        ontap: () {
                          Navigation.to(context, DonorListDivison());
                        },
                        title: 'Add Admin',
                        iconData: Icons.list,
                      ),
                      CommonButton(
                        ontap: () {
                          Navigation.to(context, DonorListDivison());
                        },
                        title: 'Approve Donor',
                        iconData: Icons.list,
                      ),

                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
