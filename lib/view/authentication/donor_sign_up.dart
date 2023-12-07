import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:muslim_blood_donor_bd/view/dashboard.dart';
import 'package:muslim_blood_donor_bd/view/authentication/login.dart';
import 'package:provider/provider.dart';

import '../../constant/app_color.dart';
import '../../constant/assets_path.dart';
import '../../constant/navigation.dart';
import '../../constant/text_style.dart';
import '../../model/data_item.dart';
import '../../view_model/provider/auth_providers.dart';
import '../../view_model/provider/data_provider.dart';
import '../../view_model/provider/registration_screen_provider.dart';
import '../../widgets/common_button_style.dart';
import '../../widgets/common_password_field.dart';
import '../../widgets/common_text_field.dart';


class DonorSignUp extends StatefulWidget {
  const DonorSignUp({super.key});

  @override
  State<DonorSignUp> createState() => _DonorSignUpState();
}

class _DonorSignUpState extends State<DonorSignUp> {
  final List<String> _bloodTypes = [
    "A+",
    "B+",
    "O+",
    "AB+",
    "A-",
    "B-",
    "O-",
    "AB-"
  ];

  late TextEditingController _emailController,
      _passController,
      _nameController,
      _phoneController;
  late AuthProviders _authProvider;
  late DataProvider _dataProvider;
  late SelectionModel _selectionModel;

  final GlobalKey<FormState> _signupKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _selectionModel = Provider.of<SelectionModel>(context, listen: false);
    _authProvider = Provider.of<AuthProviders>(context, listen: false);
    _dataProvider = Provider.of<DataProvider>(context, listen: false);
    _emailController = TextEditingController();
    _passController = TextEditingController();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _dataProvider.loadDivisionJsonData();
    _dataProvider.loadDistrictJsonData();
    _dataProvider.loadUpazilasJsonData();
    Future.delayed(Duration.zero, () {
      _selectionModel.reset();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _authProvider.dispose();
    _dataProvider.dispose();
    Provider.of<SelectionModel>(context, listen: false).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width * 0.3;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Become A Donor'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AssetsPath.logo,
                width: screenWidth,
              ),
              Expanded(child: _signupForm()),
              InkWell(
                onTap: () {
                  Navigation.to(context, const Login());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Have An Account?? ',
                      style: TextStyles.style16(dark),
                    ),
                    Text(
                      "Login",
                      style: TextStyles.style16(primaryColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signup() async {
    final email = _emailController.text.trim();
    final password = _passController.text;
    final phone = _phoneController.text;
    final name = _nameController.text;
    final divison = _selectionModel.selectedDivision?.name.toString();
    final district = _selectionModel.selectedDistrict?.name.toString();
    final area = _selectionModel.selectedArea?.name.toString();
    final blood = _selectionModel.selectedBloodGroup.toString();

    if (_signupKey.currentState?.validate() ?? false) {
      bool success = await _authProvider.signUp(
          email, password, name, phone, divison!, district!, area!, blood);
      _handleSignupResult(success);
    }

    unfocus();
  }

  void unfocus() {
    FocusScope.of(context).unfocus();
  }

  void _handleSignupResult(bool success) {
    if (success) {
      Navigation.to(context, const Dashboard());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Sign Up failed. Please Retry."),
        ),
      );
    }
  }

  Form _signupForm() {
    return Form(
      key: _signupKey,
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          CommonTextField(
            controller: _emailController,
            validator: _emailValidation,
            hinttext: 'Email Address',
            textInputType: TextInputType.emailAddress,
          ),
          const SizedBox(
            height: 16,
          ),
          CommonTextField(
            controller: _nameController,
            validator: _nameValidation,
            hinttext: 'Full Name',
            textInputType: TextInputType.name,
          ),
          const SizedBox(
            height: 16,
          ),
          Consumer<SelectionModel>(
            builder: (context, selectionModel, child) {
              final dataProvider = Provider.of<DataProvider>(context);

              return DropdownButtonFormField<DataItem>(
                hint: const Text('Selete Division'),
                value: selectionModel.selectedDivision,
                items: dataProvider.divisions.map((DataItem item) {
                  return DropdownMenuItem<DataItem>(
                    value: item,
                    child: Text(item.name ?? "No Name"),
                  );
                }).toList(),
                onChanged: (DataItem? newValue) {
                  selectionModel.setDivision(newValue!);
                },
                validator: (DataItem? value) {
                  if (value == null) {
                    return 'Please select a Divison'; // Replace with your validation message
                  }
                  return null; // Return null if the selection is valid
                },
              );
            },
          ),
          const SizedBox(height: 16),

          // Dropdown for District
          Consumer<SelectionModel>(
            builder: (context, selectionModel, child) {
              final dataProvider = Provider.of<DataProvider>(context);

              if (selectionModel.selectedDivision == null) {
                return const SizedBox(
                  width: 1,
                ); // Hide if no division selected
              }
              return Column(
                children: [
                  DropdownButtonFormField<DataItem>(
                    hint: const Text('Selete District'),
                    value: selectionModel.selectedDistrict,
                    items: dataProvider.districts
                        .where((district) =>
                            district.division_id ==
                            selectionModel.selectedDivision!.id)
                        .map((DataItem item) {
                      return DropdownMenuItem<DataItem>(
                        value: item,
                        child: Text(item.name ?? "No Name"),
                      );
                    }).toList(),
                    onChanged: (DataItem? newValue) {
                      selectionModel.setDistrict(newValue!);
                    },
                    validator: (DataItem? value) {
                      if (value == null) {
                        return 'Please select a district'; // Replace with your validation message
                      }
                      return null; // Return null if the selection is valid
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  )
                ],
              );
            },
          ),

          // Dropdown for Upazila
          Consumer<SelectionModel>(
            builder: (context, selectionModel, child) {
              final dataProvider = Provider.of<DataProvider>(context);

              if (selectionModel.selectedDivision == null ||
                  selectionModel.selectedDistrict == null) {
                return const SizedBox(
                  width: 1,
                ); // Hide if division or district not selected
              }
              return Column(
                children: [
                  DropdownButtonFormField<DataItem>(
                    hint: const Text('Selete Area'),
                    value: selectionModel.selectedArea,
                    items: dataProvider.area
                        .where((area) =>
                            area.district_id ==
                            selectionModel.selectedDistrict!.id)
                        .map((DataItem item) {
                      return DropdownMenuItem<DataItem>(
                        value: item,
                        child: Text(item.postOffice ?? "No Name"),
                      );
                    }).toList(),
                    onChanged: (DataItem? newValue) {
                      selectionModel.setUpazila(newValue!);
                    },
                    validator: (DataItem? value) {
                      if (value == null) {
                        return 'Please select a Area'; // Replace with your validation message
                      }
                      return null; // Return null if the selection is valid
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              );
            },
          ),
          // SizedBox(
          //   height: 16,
          // ),
          CommonTextField(
            controller: _phoneController,
            validator: _phoneValidation,
            hinttext: 'Phone Number',
            textInputType: TextInputType.phone,
          ),
          const SizedBox(
            height: 16,
          ),
          Consumer<SelectionModel>(
            builder: (context, selectionModel, child) {
              return DropdownButtonFormField<String>(
                value: selectionModel.selectedBloodGroup,
                // Bind to the selected Blood Group in SelectionModel
                items: _bloodTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (newValue) {
                  selectionModel.setBloodGroup(
                      newValue!); // Call setBloodGroup from SelectionModel
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select Blood Group'; // Replace with your validation message
                  }
                  return null; // Return null if the selection is valid
                },
                decoration: const InputDecoration(
                  hintText: "Blood Type",
                ),
              );
            },
          ),
          const SizedBox(
            height: 16,
          ),
          CommonPassTextField(
            controller: _passController,
            validator: _passValidation,
            hinttext: 'Password',
            textInputType: TextInputType.visiblePassword,
          ),
          const SizedBox(
            height: 20,
          ),
          Consumer<AuthProviders>(
            builder: (context, authProvider, child) {
              return authProvider.isLoading
                  ? const SizedBox(width: double.infinity,
                      child:
                          CircularProgressIndicator()) // Show the loading indicator if isLoading is true
                  : CommonButtonStyle(
                      title: 'Register',
                      onTap: () {
                        _signup();
                      },
                    );
            },
          )
        ],
      ),
    );
  }

  _passValidation(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Enter Your password';
    }
    return null;
  }

  _phoneValidation(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Phone Number';
    }

    return null;
  }

  _nameValidation(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Enter Your Name';
    }

    return null;
  }

  _emailValidation(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Enter A Valid Email';
    }
    if (!EmailValidator.validate(_emailController.text.trim())) {
      return "Enter a valid Email";
    }
    return null;
  }
}
