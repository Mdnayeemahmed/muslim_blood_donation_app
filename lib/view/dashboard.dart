import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:muslim_blood_donor_bd/constant/common_button.dart';
import 'package:muslim_blood_donor_bd/view/about_us/about_us.dart';
import 'package:muslim_blood_donor_bd/view/admin/add_admin.dart';
import 'package:muslim_blood_donor_bd/view/approve_donor/add_donor.dart';
import 'package:muslim_blood_donor_bd/view/approve_donor/approve_donor.dart';
import 'package:muslim_blood_donor_bd/view/donation/pay_now.dart';
import 'package:muslim_blood_donor_bd/view/feed/news_feed.dart';
import 'package:muslim_blood_donor_bd/view/privacy.dart';
import 'package:muslim_blood_donor_bd/view/profile/current_profile_page.dart';
import 'package:muslim_blood_donor_bd/view/req_blood/req_list.dart';
import 'package:muslim_blood_donor_bd/view/search_donor/donor_list_divison.dart';
import 'package:muslim_blood_donor_bd/view/update_user/updateUser.dart';
import 'package:muslim_blood_donor_bd/view/why_donate.dart';
import 'package:open_file/open_file.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constant/assets_path.dart';
import '../constant/hard_text.dart';
import '../constant/navigation.dart';
import '../view_model/helper/paths.dart';
import '../view_model/provider/auth_providers.dart';
import '../widgets/snackbar.dart';
import 'donation/edit_donate.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isAdmin = true;
  bool isUserApproved = false;
  String uid = '';

  @override
  void initState() {
    loadIsAdminStatus();
    checkUserApprovalStatus();
    super.initState();
  }

  Future<void> checkUserApprovalStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? collection = Paths.database.collectionUser;

    String? userId = prefs.getString('uid');

    if (uid != null) {
      setState(() {
        uid = userId!;
      });
      // Create a stream to listen for changes in the document
      Stream<DocumentSnapshot<Map<String, dynamic>>> stream = FirebaseFirestore
          .instance
          .collection(collection)
          .doc(userId)
          .snapshots();

      // Subscribe to the stream
      stream.listen((DocumentSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.exists) {
          // Check the approve_status
          bool approved = snapshot['approve_status'] ?? false;

          setState(() {
            isUserApproved = approved;
          });
        }
      }, onError: (error) {});
    }
  }

  Future<void> loadIsAdminStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isAdmin = prefs.getBool('isAdmin') ?? false;
      print(isAdmin);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              // Show an AlertDialog
              bool confirmLogout = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pop(false); // User canceled logout
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pop(true); // User confirmed logout
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  );
                },
              );

              // Perform logout if the user confirmed
              if (confirmLogout == true) {
                await AuthProviders().logout(context);
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(6),
            children: [
              ListTile(
                title: const Text('Why Donate'),
                onTap: () {
                  Navigator.pop(context);
                  Navigation.to(context, WhyDonate());
                },
              ),
              ExpansionTile(title: Text('Communication'), children: [
                ListTile(
                  title: Text('Live Chat'),
                  onTap: () {
                    launchExternalUrl(HardText.m);
                  },
                ),
                ListTile(
                  title: Text('Any Query'),
                  onTap: () {
                    launchExternalUrl(HardText.m);
                  },
                ),
                ListTile(
                  title: Text('Any Problem'),
                  onTap: () {
                    launchExternalUrl(HardText.m);
                    // Add your navigation logic here
                  },
                ),
              ]),
              ListTile(
                title: Text('Privacy'),
                onTap: () async {
                  Navigation.to(context, PrivacyScreen());
                },
              ),
              ListTile(
                title: Text('Share'),
                onTap: () {
                  // Handle the tap on the first menu item
                  // For example, navigate to another screen
                  Navigator.pop(context); // Close the drawer
                  shareApp();
                },
              ),
              ListTile(
                title: Text('Settings'),
                onTap: () {
                  SnackbarUtils.showMessage(
                      context, 'For Settings Go to Mobile settings');
                  Navigator.pop(context); // Close the drawer
                  // Add your navigation logic here
                },
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                width: screenWidth,
                child: Image.asset(
                  AssetsPath.banner,
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
                      if (isAdmin)
                        CommonButton(
                          ontap: () {
                            Navigation.to(context, const DonorListDivison());
                          },
                          title: 'Donor List',
                          iconData: Icons.list,
                        ),
                      if (isUserApproved || isAdmin)
                        CommonButton(
                          ontap: () {
                            Navigation.to(context, const ReqList());
                          },
                          title: 'Blood Request',
                          iconData: Icons.bloodtype,
                        ),
                      CommonButton(
                          ontap: () {
                            Navigation.to(context, const CurrentProfilePage());
                          },
                          title: 'Profile',
                          iconData: Icons.handshake_outlined),
                      CommonButton(
                        ontap: () {
                          Navigation.to(context, const Newsfeed());
                        },
                        title: 'Feed',
                        iconData: Icons.newspaper,
                      ),
                      CommonButton(
                        ontap: () {
                          Navigation.to(context, const PayNow());
                        },
                        title: 'Donate Us',
                        iconData: Icons.monetization_on_outlined,
                      ),
                      CommonButton(
                        ontap: () {
                          Navigation.to(context, const AboutUs());
                        },
                        title: 'About Us',
                        iconData: Icons.info_outline,
                      ),
                      if (isAdmin)
                        CommonButton(
                          ontap: () {
                            Navigation.to(context, const AddDonor());
                          },
                          title: 'Register User',
                          iconData: Icons.supervised_user_circle,
                        ),
                      if (isAdmin)
                        CommonButton(
                          ontap: () {
                            Navigation.to(context, const EditDonate());
                          },
                          title: 'Edit Donation',
                          iconData: Icons.monetization_on,
                        ),
                      if (isAdmin)
                        CommonButton(
                          ontap: () {
                            Navigation.to(context, const AddAdmin());
                          },
                          title: 'Add Admin',
                          iconData: Icons.admin_panel_settings,
                        ),
                      if (isAdmin)
                        CommonButton(
                          ontap: () {
                            Navigation.to(context, const ApproveDonor());
                          },
                          title: 'Approve Donor',
                          iconData: Icons.check_box,
                        ),
                      if (isAdmin)
                        CommonButton(
                          ontap: () {
                            Navigation.to(context, UserListScreen(uid: uid));
                          },
                          title: 'Update Donor',
                          iconData: Icons.edit,
                        ),
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> launchExternalUrl(String url) async {
    try {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  void shareApp() {
    final String text =
        'Check out this amazing app! Download it now:\nhttps://drive.google.com/file/d/1_MmULw_S0oTzBcI1lu9txuJvN681-2pV/view?usp=drive_link';
    Share.share(text, subject: 'Check out this app!');
  }
}
