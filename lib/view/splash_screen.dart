import 'package:flutter/material.dart';
import 'package:muslim_blood_donor_bd/constant/app_color.dart';
import 'package:muslim_blood_donor_bd/constant/assets_path.dart';
import 'package:muslim_blood_donor_bd/constant/hard_text.dart';
import 'package:muslim_blood_donor_bd/constant/navigation.dart';
import 'package:muslim_blood_donor_bd/constant/text_style.dart';
import 'package:muslim_blood_donor_bd/view/authentication/login.dart';
import 'package:provider/provider.dart';
import '../view_model/provider/splash_screen_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SplashScreenProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<SplashScreenProvider>(context, listen: false);
    Future.delayed(const Duration(seconds: 2), () {
      _provider.updateLogoOpacity(1.0);
      _provider.updateprogressOpacity(1.0);
      Future.delayed(const Duration(seconds: 1), () {
        _provider.updateTextOpacity(1.0);
        Future.delayed(const Duration(seconds: 2), () {
          Navigation.offAll(context, const Login());
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width * 0.7;
    return Consumer<SplashScreenProvider>(
      builder: (BuildContext context, provider, Widget? child) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedOpacity(
                  duration: const Duration(seconds: 1),
                  opacity: provider.model.logoOpacity,
                  child: Image.asset(
                    AssetsPath.logo,
                    width: screenWidth,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(seconds: 1),
                  opacity: provider.model.textOpacity,
                  child: Text(
                    HardText.verse,
                    style: TextStyles.style16BoldBangla(primaryColor),
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(seconds: 1),
                  opacity: provider.model.textOpacity,
                  child: Text(
                    HardText.Reference,
                    style: TextStyles.style16BoldBangla(dark),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                AnimatedOpacity(
                  opacity: provider.model.progressOpacity,
                  duration: const Duration(seconds: 1),
                  child: const CircularProgressIndicator(),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
