import 'package:flutter/cupertino.dart';

import '../../model/splash_screen_model.dart';

class SplashScreenProvider extends ChangeNotifier {
  final SplashScreenModel _model = SplashScreenModel();

  SplashScreenModel get model => _model;

  void updateLogoOpacity(double opacity) {
    _model.logoOpacity = opacity;
    notifyListeners();
  }

  void updateTextOpacity(double opacity) {
    _model.textOpacity = opacity;
    notifyListeners();
  }

  void updateprogressOpacity(double opacity) {
    _model.progressOpacity = opacity;
    notifyListeners();
  }
}
