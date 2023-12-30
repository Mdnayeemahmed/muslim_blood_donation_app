import 'package:flutter/material.dart';
import 'package:muslim_blood_donor_bd/model/user_model.dart';
import 'package:provider/provider.dart';
import 'package:muslim_blood_donor_bd/view_model/provider/profile_update_provider.dart';

import '../../widgets/common_button_style.dart';
import '../../widgets/snackbar.dart';

class UserDetailScreen extends StatefulWidget {
  final UserModel user;

  const UserDetailScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late TextEditingController _counterController;
  late TextEditingController _dobController;
  late TextEditingController _lastDonateController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;

  late UserModel _currentUser;

  @override
  void initState() {
    super.initState();
    _counterController =
        TextEditingController(text: widget.user.counter ?? '0');
    _dobController = TextEditingController(text: widget.user.dateofbirth ?? '');
    _lastDonateController =
        TextEditingController(text: widget.user.lastDonateDate ?? '');
    _phoneController = TextEditingController(text: widget.user.userPhone ?? '');
    _currentUser = widget.user;
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 8),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: widget.user.userPhotoUrl != null
                      ? NetworkImage(widget.user.userPhotoUrl!)
                      : const NetworkImage(
                          'https://cdn-icons-png.flaticon.com/512/9131/9131529.png'),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.user.userName ?? 'No Name',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 2),
                    if (widget.user.approve_status == true)
                      const Icon(
                        Icons.verified,
                        color: Colors.green,
                      ),
                    if (widget.user.approve_status == false)
                      const Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(widget.user.userEmail ?? ''),
                const SizedBox(height: 8),
                Text(
                    'Last Donate Date: ${widget.user.lastDonateDate ?? "No Information Found"}'),
                const SizedBox(height: 8),
                Column(
                  children: [
                    if (widget.user.isAvailable == true)
                      const Text(
                        'Status : Available',
                        style: TextStyle(
                            // Add your style settings here...
                            ),
                      )
                    else
                      const Text(
                        'Status : Away',
                        style: TextStyle(
                            // Add your style settings here...
                            ),
                      ),
                  ],
                ),
                Column(
                  children: [
                    if (widget.user.admin == true)
                      const Text(
                        'Type : Admin',
                        style: TextStyle(
                            // Add your style settings here...
                            ),
                      )
                    else
                      const Text(
                        'Type : User',
                        style: TextStyle(
                            // Add your style settings here...
                            ),
                      ),
                  ],
                ),
                Expanded(child: _userDetailsForm(widget.user)),
                const SizedBox(height: 16),
                CommonButtonStyle(
                  onTap: () async {
                    bool success = await Provider.of<ProfileUpdateProvider>(
                      context,
                      listen: false,
                    ).update(
                        uid: widget.user.userId!,
                        donateDate: _lastDonateController.text,
                        socialMediaLink: widget.user.socialMediaLink,
                        reference: widget.user.reference,
                        condition: widget.user.condition,
                        birthday: _dobController.text,
                        phone: _phoneController.text,
                        counter: _counterController.text);

                    if (success) {
                      SnackbarUtils.showMessage(context, 'Update Successfully');
                    } else {
                      SnackbarUtils.showMessage(
                          context, 'Failed to Update Details');
                    }

                    Navigator.pop(context);
                  },
                  title: 'Save',
                ),
                CommonButtonStyle(
                  onTap: () async {
                    String? password = await _showPasswordInputDialog(context);

                    if (password != null && password.isNotEmpty) {
                      bool success = await Provider.of<ProfileUpdateProvider>(
                        context,
                        listen: false,
                      ).deleteUser(widget.user.userId!, password);

                      if (success) {
                        SnackbarUtils.showMessage(
                            context, 'Deleted Successfully');
                      } else {
                        SnackbarUtils.showMessage(context, 'Failed To delete');
                      }

                      Navigator.pop(context);
                    }
                  },
                  title: 'Delete User',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Form _userDetailsForm(UserModel user) {
    return Form(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          const SizedBox(height: 8),
          TextFormField(
            controller: _counterController,
            decoration: const InputDecoration(
              labelText: 'Blood Donated',
            ),
            readOnly: false,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _dobController,
            decoration: const InputDecoration(
              labelText: 'Date Of Birth',
            ),
            readOnly: false,
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: user.userBloodType ?? '',
            decoration: const InputDecoration(
              labelText: 'Blood Group',
            ),
            readOnly: true,
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: user.userDivison != null
                ? "${user.userDivison} Division, ${user.userDistrict} District, ${user.userArea} Area"
                : '',
            decoration: const InputDecoration(
              labelText: 'Address',
            ),
            readOnly: true,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Mobile',
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: user.reference ?? '',
            decoration: const InputDecoration(
              labelText: 'Reference',
            ),
            readOnly: false,
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: user.condition ?? '',
            decoration: const InputDecoration(
              labelText: 'Condition',
            ),
            readOnly: false,
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: user.socialMediaLink ?? '',
            decoration: const InputDecoration(
              labelText: 'Social Media Link',
            ),
            readOnly: false,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _counterController.dispose();
    _dobController.dispose();
    _lastDonateController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<String?> _showPasswordInputDialog(BuildContext context) async {
    return await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Enter Your Password"),
            content: TextFormField(
              obscureText: true,
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              onChanged: (value) {
                // Handle password input
              },
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(_passwordController.text);
                },
                child: const Text("OK"),
              ),
            ],
          );
        });
  }
}
