import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:muslim_blood_donor_bd/constant/app_color.dart';
import 'package:muslim_blood_donor_bd/constant/text_style.dart';
import 'package:muslim_blood_donor_bd/model/user_model.dart';
import 'package:muslim_blood_donor_bd/view/dashboard.dart';
import 'package:muslim_blood_donor_bd/view_model/provider/profile_update_provider.dart';
import 'package:provider/provider.dart';
import '../../constant/datautils.dart';
import '../../constant/navigation.dart';
import '../../view_model/provider/auth_providers.dart';
import '../../view_model/services/database_service.dart';
import '../../widgets/common_button_style.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

import '../../widgets/snackbar.dart';

class CurrentProfilePage extends StatefulWidget {
  const CurrentProfilePage({Key? key}) : super(key: key);

  @override
  State<CurrentProfilePage> createState() => _CurrentProfilePageState();
}

class _CurrentProfilePageState extends State<CurrentProfilePage> {
  late final ImagePicker _imagePicker = ImagePicker();
  late String _downloadUrl = '';
  late String _image = '';
  late String counter = '';
  bool _selectedOption = true;

  late final TextEditingController _bloodET,
      _addressET,
      _mobileET,
      _dateET,
      _passwordET,
      _passwordCET,
      _referenceET,
      _conditionET,
      _socialMediaLinkET,
      _dateofbirth;

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
    _referenceET = TextEditingController(); // Initialize reference controller
    _conditionET = TextEditingController();
    _dateofbirth = TextEditingController();
    _socialMediaLinkET =
        TextEditingController(); // Initialize social media link controller

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

              return Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          // Border color
                          borderRadius:
                              BorderRadius.circular(5.0), // Border radius
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        // Adjust padding as needed
                        child: Column(
                          children: [
                            const Text('Blood Donated'),
                            Text(
                              counter,
                              style:
                                  const TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Consumer<ProfileUpdateProvider>(
                      builder: (context, updateProvider, child) {
                        return FutureBuilder(
                          future: updateProvider.getuid(),
                          builder: (context, snapshot) {
                            return Align(
                              alignment: Alignment.topRight,
                              child: OutlinedButton(
                                onPressed: () {
                                  _performUpdate(context, updateProvider);
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: primaryColor,
                                  ),
                                ),
                                child: const Text('Update'),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Stack(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _downloadUrl.isNotEmpty
                            ? NetworkImage(_downloadUrl)
                            : NetworkImage(_image) as ImageProvider<Object>?,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: -15,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: () {
                          _pickImage();
                        },
                      ),
                    ),
                  ],
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
                    if (user.approve_status == true)
                      InkWell(
                        onTap: () {
                          SnackbarUtils.showMessage(
                              context, 'You are verified');
                        },
                        child: const Icon(
                          Icons.verified,
                          color: Colors.green,
                        ),
                      ),
                    if (user.approve_status == false)
                      InkWell(
                        onTap: () {
                          SnackbarUtils.showMessage(context,
                              'Sorry! You are not verified. Talk with admin');
                        },
                        child: const Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  user.userEmail ?? '',
                ),
                const SizedBox(height: 3),
                GestureDetector(
                  onTap: () => DateUtilsfunction.pickDate(
                      context, true, _dateET, _profile.updateLastDonateDate),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Last Donate Date : ',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      Text(
                        _dateET.text,
                        style: const TextStyle(
                            fontSize: 16,
                            color:
                                Colors.black), // Customize the style as needed
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Status'),
                    const SizedBox(width: 3),
                    DropdownButton<String>(
                      value: _profile.isAvailable ? 'Available' : 'Away',
                      items: const [
                        DropdownMenuItem(
                          value: 'Available',
                          child: Text('Available'),
                        ),
                        DropdownMenuItem(
                          value: 'Away',
                          child: Text('Away'),
                        ),
                      ],
                      onChanged: (String? newValue) async {
                        bool newStatus = newValue == 'Available';
                        _profile.updateStatus(newStatus);

                        // Perform your database update here using the newStatus value
                        await DatabaseService.update(
                          'user_data_collection',
                          _profile.uid!,
                          {'isAvailable': newStatus},
                        );
                      },
                    ),
                  ],
                ),
                Expanded(child: _signupForm()),
              ]);
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
          const SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Date Of Birth',
            ),
            controller: _dateofbirth,
            readOnly: true,
            onTap: () => DateUtilsfunction.pickDate(
                context, true, _dateofbirth, _profile.updateBirthDate),
          ),
          const SizedBox(height: 8),
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
          const SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Reference',
            ),
            controller: _referenceET,
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Condition',
            ),
            controller: _conditionET,
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Social Media Link',
            ),
            controller: _socialMediaLinkET,
          ),
          const SizedBox(height: 8),
          const Divider(),
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
    _referenceET.text = user.reference ?? ''; // Set reference with initial data
    _conditionET.text = user.condition ?? ''; // Set condition with initial data
    _socialMediaLinkET.text = user.socialMediaLink ?? '';
    _image = user.userPhotoUrl ??
        'https://cdn-icons-png.flaticon.com/512/9131/9131529.png'; // Set socialMediaLink with initial data

    _mobileET.text = user.userPhone!;
    counter = user.counter ?? '0';
    _dateofbirth.text = user.dateofbirth ?? '';
    _selectedOption = user.isAvailable ?? true;
  }

  void _performUpdate(BuildContext context, ProfileUpdateProvider updateProvider) async {
    final uid = _profile.uid;
    final date = _dateET.text;
    final reference = _referenceET.text;
    final condition = _conditionET.text;
    final socialMediaLink = _socialMediaLinkET.text;
    final dateofbirth = _dateofbirth.text;

    if (kDebugMode) {

    }

    bool success = await _profile.update(
      uid: uid.toString(),
      donateDate: date,
      reference: reference,
      condition: condition,
      socialMediaLink: socialMediaLink,
      birthday: dateofbirth,
    );

    if (success) {
      _profile.clearLastDonateDate();
      Navigation.offAll(context, const Dashboard());

      SnackbarUtils.showMessage(context, 'Update Successfully');
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
                      child: CircularProgressIndicator(),
                    )
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
        SnackbarUtils.showMessage(
            context, 'Password Changed Successfully');

      } else {
        SnackbarUtils.showMessage(
            context, 'Invalid');

      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Upload the image to Firebase Storage
      _uploadImage(File(pickedFile.path));
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    try {
      final firebase_storage.Reference ref = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${_profile.uid}.jpg');

      await ref.putFile(imageFile);

      // Get the download URL of the uploaded image
      final String downloadUrl = await ref.getDownloadURL();

      // Update the Firestore document with the download URL
      _updateUserProfilePhoto(downloadUrl);
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image: $e');
      }
    }
  }

  Future<void> _updateUserProfilePhoto(String downloadUrl) async {
    try {
      await DatabaseService.update(
        'user_data_collection',
        _profile.uid!,
        {'user_photo_url': downloadUrl},
      );

      _profile.updateProfilePhotoUrl(downloadUrl);

      SnackbarUtils.showMessage(context, 'Profile Image Updated');
    } catch (e) {
      SnackbarUtils.showMessage(
          context, 'Error updating profile picture URL: $e');
    }
  }
}
