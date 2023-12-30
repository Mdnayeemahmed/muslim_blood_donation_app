import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:muslim_blood_donor_bd/view/authentication/login.dart';

import '../../constant/navigation.dart';

class ResetPass extends StatefulWidget {
  const ResetPass({Key? key});

  @override
  _ResetPassState createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  // Function to handle the password reset
  Future<void> _resetPassword(BuildContext context, String email) async {
    try {
      setState(() {
        isLoading = true;
      });

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset email sent successfully.'),
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate to the login page after a delay (to show the SnackBar)
      Future.delayed(Duration(seconds: 1), () {
        Navigator.of(context).pop(); // Close the current screen
        // Navigate to the login page (replace it with your login screen route)
        Navigation.offAll(context, Login());
      });
    } catch (e) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending password reset email: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                String email = emailController.text.trim();
                _resetPassword(context, email);
              },
              child: isLoading
                  ? CircularProgressIndicator()
                  : Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}

