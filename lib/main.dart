import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:muslim_blood_donor_bd/constant/app_theme.dart';
import 'package:muslim_blood_donor_bd/view_model/provider/auth_providers.dart';
import 'package:muslim_blood_donor_bd/view_model/provider/create_req_provider.dart';
import 'package:muslim_blood_donor_bd/view_model/provider/data_provider.dart';
import 'package:muslim_blood_donor_bd/view_model/provider/edit_donate_provider.dart';
import 'package:muslim_blood_donor_bd/view_model/provider/post_provider.dart';
import 'package:muslim_blood_donor_bd/view_model/provider/profile_update_provider.dart';
import 'package:muslim_blood_donor_bd/view_model/provider/registration_screen_provider.dart';
import 'package:muslim_blood_donor_bd/view/splash_screen.dart';
import 'package:muslim_blood_donor_bd/view_model/provider/splash_screen_provider.dart';
import 'package:muslim_blood_donor_bd/view_model/services/notification.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  runApp(const MyApp());
}

Future backgroundHandler(RemoteMessage msg) async {
  print('Handling background message: ${msg.notification?.title}');

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();


}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    LocalNotificationService.initialize();

    FirebaseMessaging.instance.getInitialMessage().then((message) {});

    FirebaseMessaging.onMessage.listen((message) {
      print('Foreground Message Received: ${message.notification?.title}');

      if (message.notification != null) {
        LocalNotificationService.display(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {});
  }

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
            create: (context) => ProfileUpdateProvider(),
        ),
        ChangeNotifierProvider<EditDonateProvider>(
          create: (context) => EditDonateProvider(),
        ),
        ChangeNotifierProvider<PostProvider>(
          create: (context) => PostProvider(),
        ),
      ],
      child: MaterialApp(
        home: const SplashScreen(),
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme(),
      ),
    );
  }
}
