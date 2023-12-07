import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:muslim_blood_donor_bd/constant/text_style.dart';
import 'package:muslim_blood_donor_bd/model/user_model.dart';
import 'package:muslim_blood_donor_bd/view_model/provider/profile_update_provider.dart';
import 'package:provider/provider.dart';

import '../../view_model/provider/auth_providers.dart';
import '../../widgets/common_button_style.dart';

class CurrentProfilePage extends StatefulWidget {
  const CurrentProfilePage({Key? key}) : super(key: key);

  @override
  State<CurrentProfilePage> createState() => _CurrentProfilePageState();
}

class _CurrentProfilePageState extends State<CurrentProfilePage> {
  late final TextEditingController _bloodET,
      _addressET,
      _mobileET,
      _dateET,
      _passwordET,
      _passwordCET;
  late ProfileUpdateProvider _profile;
  late AuthProviders _authProvider;

  final GlobalKey<FormState> _updateKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _bloodET = TextEditingController();
    _addressET = TextEditingController();
    _mobileET = TextEditingController();
    _dateET = TextEditingController();
    _passwordET = TextEditingController();
    _passwordCET = TextEditingController();
    _authProvider = Provider.of<AuthProviders>(context, listen: false);
    _profile = Provider.of<ProfileUpdateProvider>(context, listen: false);
    Future.delayed(const Duration(seconds: 4), () {
      _profile.getuid(); // Initialize _uid after a delay of 4 seconds
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _profile.getuid(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (_profile.uid != null) {
              return buildProfileScreen();
            } else {
              return const Text('No data available');
            }
          },
        ),
      ),
    );
  }

  Widget buildProfileScreen() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('user_data_collection')
              .doc(_profile.uid!)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Text('No data available');
            } else {
              final UserModel user = UserModel.fromJson(snapshot.data!.data()!);
              _updateTextFields(user);

              return Column(
                children: [
                  const SizedBox(height: 16),
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/logo/logo.png'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        user.userName ?? 'No Name',
                        style: TextStyles.style16Bold(Colors.black),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.verified,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    user.userEmail ?? '',
                  ),
                  const SizedBox(height: 8),
                  Expanded(child: _signupForm()),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Form _signupForm() {
    return Form(
      key: _updateKey,
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Blood Group',
            ),
            controller: _bloodET,
            readOnly: true,
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Address',
            ),
            controller: _addressET,
            readOnly: true,
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Mobile',
            ),
            controller: _mobileET,
            readOnly: true,
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Last Donate Date',
            ),
            controller: _dateET,
            readOnly: true,
            onTap: () => _pickDate(context),
          ),
          const SizedBox(height: 8),
          _profile.isLoading
              ? const Center(
                  child:
                      CircularProgressIndicator()) // Show the loading indicator if isLoading is true
              : CommonButtonStyle(
                  title: 'Update',
                  onTap: () {
                    _update(_profile);
                  },
                ),
          const SizedBox(height: 8),
          Text(
            'Password Change',
            style: TextStyles.style16Bold(Colors.black),
          ),
          const Divider(),
          _passwordForm(),
        ],
      ),
    );
  }

  void _updateTextFields(UserModel user) {
    _bloodET.text = user.userBloodType!;
    String location =
        "${user.userDivison} Division, ${user.userDistrict} District, ${user.userArea} Area";
    _addressET.text = location;

    _dateET.text = user.lastDonateDate ?? '';
    _mobileET.text = user.userPhone!;
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      // Format the selected date
      final formattedDate = DateFormat('dd MMM yyyy').format(picked);
      _dateET.text = formattedDate;
      _profile.updateLastDonateDate(picked);
    }
  }

  Future<void> _update(ProfileUpdateProvider updateProvider) async {
    final uid = _profile.uid;
    final date = _dateET.text;
    if (kDebugMode) {
      print(date);
    }
    const link = null;

    bool success = await updateProvider.update(
      uid: uid.toString(),
      donateDate: date,
      socialMediaLink: link,
    );

    if (success) {
      updateProvider.clearLastDonateDate();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Update successful!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Form _passwordForm() {
    return Form(
      key: _passwordKey,
      child: Consumer<AuthProviders>(
        builder: (context, authProvider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                ),
                controller: _passwordCET,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'New Password',
                ),
                controller: _passwordET,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              authProvider.isLoading
                  ? const Center(
                      child:
                          CircularProgressIndicator()) // Show the loading indicator if isLoading is true
                  : CommonButtonStyle(
                      title: 'Change Password',
                      onTap: () {
                        _changePassword(_authProvider);
                      },
                    ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _changePassword(AuthProviders authProvider) async {
    final currentpassword = _passwordCET.text;
    final newPassword = _passwordET.text;
    if (_passwordKey.currentState?.validate() ?? false) {
      bool success =
          await _authProvider.changePassword(currentpassword, newPassword);

      if (success) {
        _passwordCET.text = '';
        _passwordET.text = '';
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password changed successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Invalid!'),
          duration: Duration(seconds: 2),
        ));
      }
    }
  }
}
