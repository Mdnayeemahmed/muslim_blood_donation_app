import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/user_model.dart';

class UserProfileProvider extends ChangeNotifier {
  Map<String, dynamic>? userData;

  void updateUserData(Map<String, dynamic> newData) {
    userData = newData;
    notifyListeners();
  }
}

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late TextEditingController _dateController;
  String newSocialMediaLink = "";

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    _fetchUserData();
    Provider.of<UserProfileProvider>(context, listen: false);
  }

  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    DocumentSnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('user_data_collection').doc(uid).get();
    Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;

    Provider.of<UserProfileProvider>(context, listen: false).updateUserData(userData);
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserProfileProvider>(context).userData != null
        ? UserModel.fromJson(Provider.of<UserProfileProvider>(context).userData!)
        : UserModel(admin: null);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 16),
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/logo/logo.png'),
              ),
              SizedBox(height: 16),
              Text(
                user.userName ?? 'Your Name',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 3),
              Text(user.userEmail ?? 'your Email'),
              SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Blood Group',
                ),
                initialValue: user.userBloodType,
                enabled: false,
              ),
              SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Address',
                ),
                initialValue: '${user.userDivison ?? ''} Divison, ${user.userDistrict ?? ''} District, ${user.userArea ?? ''} Area',
                enabled: false,
                maxLines: 2,
              ),
              SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Mobile',
                ),
                initialValue: user.userPhone,
                enabled: false,
              ),
              SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Last Donate Date',
                ),
                controller: _dateController,
                onTap: () => _selectDate(context),
                enabled: true,
              ),
              SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Social Media Link',
                ),
                initialValue: 'No Information found',
                enabled: true,
                onChanged: (value) {
                  newSocialMediaLink = value;
                },
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  // Your update logic here
                },
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd MMM, yyyy').format(pickedDate);
      _dateController.text = formattedDate;
    }
  }
}
