import 'package:flutter/material.dart';
import 'package:muslim_blood_donor_bd/view_model/provider/edit_donate_provider.dart';
import 'package:muslim_blood_donor_bd/widgets/common_button_style.dart';
import 'package:muslim_blood_donor_bd/widgets/common_text_field.dart';
import 'package:provider/provider.dart';

import '../../constant/navigation.dart';
import '../dashboard.dart';

class EditDonate extends StatefulWidget {
  const EditDonate({super.key});

  @override
  State<EditDonate> createState() => _EditDonateState();
}

class _EditDonateState extends State<EditDonate> {
  late TextEditingController titleController, linkController;
  final GlobalKey<FormState> _editDonate = GlobalKey<FormState>();
  late EditDonateProvider _editDonateProvider;

  @override
  void initState() {
    titleController = TextEditingController();
    linkController = TextEditingController();
    _editDonateProvider =
        Provider.of<EditDonateProvider>(context, listen: false);

    final docID = 'payment_Donate'; // Replace with your actual docID
    _editDonateProvider.fetchData(docID).then((donate) {
      if (donate != null) {
        // Set the data in the controllers
        titleController.text = donate.title ?? '';
        linkController.text = donate.link ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Donation Link'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _editDonate,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CommonTextField(
                    validator: _titleValidation,
                    controller: titleController,
                    hinttext: 'Platform'),
                const SizedBox(
                  height: 16,
                ),
                CommonTextField(
                    validator: _linkValidation,
                    controller: linkController,
                    hinttext: 'Provide Link'),
                const SizedBox(
                  height: 16,
                ),
                CommonButtonStyle(title: 'Submit', onTap: _submitLink),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitLink() async {
    final title = titleController.text;
    final link = linkController.text;

    if (_editDonate.currentState?.validate() ?? false) {
      bool success = await _editDonateProvider.submit(title, link);

      if (success) {
        print('true');
        Navigation.offAll(context, const Dashboard());
      } else {
        print('xyz');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Something Went Wrong"),
          ),
        );
      }
    }
    FocusScope.of(context).unfocus();
  }
}

_titleValidation(String? value) {
  if (value?.isEmpty ?? true) {
    return 'Platform Name';
  }

  return null;
}

_linkValidation(String? value) {
  if (value?.isEmpty ?? true) {
    return 'provide link';
  }

  return null;
}
