import 'package:flutter/material.dart';
import 'package:muslim_blood_donor_bd/constant/app_color.dart';
import 'package:muslim_blood_donor_bd/constant/assets_path.dart';
import 'package:muslim_blood_donor_bd/constant/hard_text.dart';
import 'package:muslim_blood_donor_bd/constant/navigation.dart';
import 'package:muslim_blood_donor_bd/constant/text_style.dart';
import 'package:muslim_blood_donor_bd/view/authentication/reset_pass.dart';
import 'package:muslim_blood_donor_bd/view/dashboard.dart';
import 'package:muslim_blood_donor_bd/widgets/common_button_style.dart';
import 'package:muslim_blood_donor_bd/widgets/common_text_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../view_model/provider/auth_providers.dart';
import '../../widgets/common_password_field.dart';
import 'donor_sign_up.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final TextEditingController _emailController, _passController;

  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();
  late AuthProviders _authProvider;

  @override
  void initState() {
    _authProvider = Provider.of<AuthProviders>(context, listen: false);
    _emailController = TextEditingController();
    _passController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width * 0.5;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      AssetsPath.logo,
                      width: screenWidth,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                        key: _loginKey,
                        child: Column(
                          children: [
                            CommonTextField(
                              controller: _emailController,
                              validator: (String? value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Enter A Valid Email';
                                }
                                if (!EmailValidator.validate(
                                    _emailController.text.trim())) {
                                  return "Enter a valid Email";
                                }
                                return null;
                              },
                              hinttext: 'Email Address',
                              textInputType: TextInputType.emailAddress,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            CommonPassTextField(
                              controller: _passController,
                              validator: (String? value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Enter Your password';
                                }
                                return null;
                              },
                              hinttext: 'Password',
                              textInputType: TextInputType.visiblePassword,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Consumer<AuthProviders>(
                              builder: (context, authProvider, child) {
                                return authProvider.isLoading
                                    ? const CircularProgressIndicator() // Show the loading indicator if isLoading is true
                                    : ElevatedButton(
                                        onPressed: _login,
                                        child: const Text("Login"),
                                      );
                              },
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 2,
                    ),
                    InkWell(
                      onTap: () async {
                        try {
                          await launchUrl(
                          Uri.parse(HardText.m),
                          mode: LaunchMode.externalApplication,
                          );
                        } catch (e) {
                          print('Error launching URL: $e');
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Facing Issue With Login?",
                            style: TextStyles.style15(dark),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),


                    InkWell(
                      onTap: () {
                        Navigation.to(context, ResetPass());
                      },
                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Forgot Password",
                            style: TextStyles.style15(dark),
                          ),
                        ],
                      ),
                    ),



                    Spacer(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CommonButtonStyle(
                          title: "Become A Donor",
                          onTap: () {
                            Navigation.to(context, DonorSignUp());
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passController.text;

    if (_loginKey.currentState?.validate() ?? false) {
      bool success = await _authProvider.login(email, password);
      print('object');

      if (success) {
        print('true');
        Navigation.offAll(context, const Dashboard());
      } else {
        print('xyz');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login failed. Please check your credentials."),
          ),
        );
      }
    }
    FocusScope.of(context).unfocus();
  }
}
