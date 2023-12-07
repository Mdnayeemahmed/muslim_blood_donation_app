import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:muslim_blood_donor_bd/constant/app_theme.dart';
import 'package:muslim_blood_donor_bd/model/user_model.dart';
import 'package:muslim_blood_donor_bd/view/profile/current_profile_page.dart';
import 'package:muslim_blood_donor_bd/view_model/provider/auth_providers.dart';
import 'package:muslim_blood_donor_bd/view_model/provider/create_req_provider.dart';
import 'package:muslim_blood_donor_bd/view_model/provider/data_provider.dart';
import 'package:muslim_blood_donor_bd/view_model/provider/profile_update_provider.dart';
import 'package:muslim_blood_donor_bd/view_model/provider/registration_screen_provider.dart';
import 'package:muslim_blood_donor_bd/view/splash_screen.dart';
import 'package:muslim_blood_donor_bd/view_model/provider/splash_screen_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SplashScreenProvider>(
            create: (context) => SplashScreenProvider()),
        ChangeNotifierProvider<DataProvider>(
          create: (context) => DataProvider(),
        ),
        ChangeNotifierProvider<SelectionModel>(
          create: (context) => SelectionModel(),
        ),
        ChangeNotifierProvider<AuthProviders>(
            create: (context) => AuthProviders()),
        ChangeNotifierProvider<CreateReqProvider>(
            create: (context) => CreateReqProvider()),
        ChangeNotifierProvider<ProfileUpdateProvider>(
            create: (context) => ProfileUpdateProvider())
      ],
      child: MaterialApp(
        home: SplashScreen(),
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme(),
      ),
    );
  }
}
