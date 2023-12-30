import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:muslim_blood_donor_bd/constant/navigation.dart';
import 'package:muslim_blood_donor_bd/view/dashboard.dart';
import 'package:provider/provider.dart';

import '../../constant/assets_path.dart';
import '../../view_model/provider/create_req_provider.dart';
import '../../view_model/services/notification.dart';
import '../../widgets/common_button_style.dart';
import '../../widgets/common_text_field.dart';

class CreateReq extends StatefulWidget {
  const CreateReq({super.key});

  @override
  State<CreateReq> createState() => _CreateReqState();
}

class _CreateReqState extends State<CreateReq> {
  final LocalNotificationService _localNotificationService=LocalNotificationService();

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
  late CreateReqProvider _createReqProvider;
  bool isDateAndTimeSelected = false;
  DateTime? selectedDateTime;


  late TextEditingController _patientNameController,
      _caseController,
      _locationController,
      _contactNameController,
      _phoneController,
      _dateTimeController,
      _amountController,
      _hospitalController;

  final GlobalKey<FormState> _reqKey = GlobalKey<FormState>();
  String? selectedBloodType;

  void initState() {
    super.initState();
    _patientNameController = TextEditingController();
    _caseController = TextEditingController();
    _locationController = TextEditingController();
    _phoneController = TextEditingController();
    _contactNameController = TextEditingController();
    _phoneController = TextEditingController();
    _dateTimeController = TextEditingController();
    _amountController = TextEditingController();
    _hospitalController=TextEditingController();
    _createReqProvider = Provider.of<CreateReqProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width * 0.3;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Request For Blood'),
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
              Expanded(child: _reqForm()),
            ],
          ),
        ),
      ),
    );
  }

  Form _reqForm() {
    return Form(
      key: _reqKey,
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          CommonTextField(
            controller: _patientNameController,
            validator: _patientNameValidation,
            hinttext: 'Patient Name',
            textInputType: TextInputType.name,
          ),
          const SizedBox(
            height: 16,
          ),
          CommonTextField(
            controller: _caseController,
            validator: _caseValidation,
            hinttext: 'Case Type',
            textInputType: TextInputType.text,
          ),
          const SizedBox(
            height: 16,
          ),
          CommonTextField(
            controller: _hospitalController,
            validator: _hospitalValidation,
            hinttext: 'Hospital Name',
            textInputType: TextInputType.text,
          ), const SizedBox(
            height: 16,
          ),
          CommonTextField(
            controller: _locationController,
            validator: _locationValidation,
            hinttext: 'Hospital Location',
            textInputType: TextInputType.text,
          ),
          const SizedBox(
            height: 16,
          ),
          DropdownButtonFormField<String>(
            items: _bloodTypes.map((String bloodType) {
              return DropdownMenuItem<String>(
                value: bloodType,
                child: Text(bloodType),
              );
            }).toList(),
            onChanged: (String? value) {
              selectedBloodType = value;
            },
            decoration: const InputDecoration(hintText: "Select Blood Type"),
            value: selectedBloodType,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Select a Blood Type';
              }
              return null;
            },
          ),const SizedBox(
            height: 16,
          ),
          CommonTextField(
            controller: _amountController,
            validator: _amountValidation,
            hinttext: 'Amount.Example 2 Bag',
            textInputType: TextInputType.number,
          ),
          const SizedBox(
            height: 16,
          ),
          CommonTextField(
            controller: _contactNameController,
            validator: _contactNameValidation,
            hinttext: 'Contact Name',
            textInputType: TextInputType.text,
          ),
          const SizedBox(
            height: 16,
          ),
          CommonTextField(
            controller: _phoneController,
            validator: _phoneValidation,
            hinttext: 'Contact Number',
            textInputType: TextInputType.phone,
          ),
          const SizedBox(
            height: 20,
          ),
          DateTimeField(
            format: DateFormat("yyyy-MM-dd hh:mm a"),
            decoration: const InputDecoration(
              labelText: "Select Date and Time",
            ),
            controller: _dateTimeController,
            initialValue: selectedDateTime,
            onShowPicker: (context, currentValue) async {
              final date = await showDatePicker(
                context: context,
                firstDate: DateTime(2000),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2101),
              );

              if (date != null) {
                TimeOfDay initialTime;
                if (currentValue != null) {
                  initialTime = TimeOfDay.fromDateTime(currentValue);
                } else {
                  // Set the initialTime based on the current time
                  final currentTime = TimeOfDay.now();
                  initialTime = currentTime;
                }

                final time = await showTimePicker(
                  context: context,
                  initialTime: initialTime,
                );

                if (time != null) {
                  final newDateTime = DateTime(
                      date.year, date.month, date.day, time.hour, time.minute);

                  // Perform your validation here (example: ensure newDateTime is in the future)
                  if (newDateTime.isBefore(DateTime.now())) {
                    return currentValue; // Return the current value if validation fails
                  }

                  // If validation is successful, set the newDateTime and update the controller
                  selectedDateTime = newDateTime;
                  _dateTimeController.text =
                      DateFormat("yyyy-MM-dd hh:mm a").format(newDateTime);

                  isDateAndTimeSelected = true; // Set the flag to true
                  return newDateTime;
                }
              }

              return currentValue;
            },
            validator: (value) {
              if (!isDateAndTimeSelected) {
                return 'Select a valid date and time';
              }
              return null; // Return null if validation passes
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Consumer<CreateReqProvider>(
            builder: (context, reqProvider, child) {
              return reqProvider.isLoading
                  ? const SizedBox(
                  width: double.infinity,
                  child:
                      AspectRatio(
                    aspectRatio: 1.0,
                    // Set the aspect ratio to 1.0 for a perfect circle
                    child: CircularProgressIndicator(),
                  ))  // Show the loading indicator if isLoading is true
                  : CommonButtonStyle(
                      title: 'Create Request',
                      onTap: () {
                        _createReq();
                      },
                    );
            },
          )
        ],
      ),
    );
  }

  _contactNameValidation(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Enter Contact Name';
    }
    return null;
  }

  String? _phoneValidation(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Phone Number is required';
    }

    // Remove any non-digit characters from the phone number
    String phoneNumber = value!.replaceAll(RegExp(r'\D'), '');

    // Check if the sanitized phone number has exactly 11 digits
    if (phoneNumber.length != 11) {
      return 'Phone Number must be 11 digits';
    }

    return null;
  }
  _patientNameValidation(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Enter Patient Name';
    }
    return null;
  }

  _locationValidation(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Enter Location';
    }
    return null;
  }

  _caseValidation(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Enter case type. ex:bike accident';
    }
    return null;
  }

  _amountValidation(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Enter Amount of blood. ex:2 Bag';
    }
    return null;
  }
  _hospitalValidation(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Enter Hospital Name';
    }
    return null;
  }

  Future<void> _createReq() async {
    final patientName = _patientNameController.text;
    final caseType = _caseController.text;
    final location = _locationController.text;
    final hospital=_hospitalController.text;
    final contactName = _contactNameController.text;
    final contactPhone = _phoneController.text;
    final blood = selectedBloodType;
    final amount = _amountController.text;
    final reqTime = selectedDateTime;

    print(reqTime);

    if (_reqKey.currentState?.validate() ?? false) {
      bool success = await _createReqProvider.reqBlood(reqTime!, patientName,
          blood!, amount, location, contactName, contactPhone, caseType,hospital);

      _handleResult(success);
    }

    unfocus();
  }

  void unfocus() {
    FocusScope.of(context).unfocus();
  }

  Future<void> _handleResult(bool success) async {
    if (success) {
      await LocalNotificationService.sendPushMessagesToAllUsers('Emergency Blood Alert','Blood Need Urgently!');
      Navigation.offAll(context, Dashboard());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Request failed. Please retry."),
        ),
      );
    }
  }
}

