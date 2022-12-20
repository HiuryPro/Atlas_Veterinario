import 'package:flutter/material.dart';

class AppController extends ChangeNotifier {
  static AppController instance = AppController();

  bool isDarkTheme = false;
  String background = "assets/images/back2.jpg";
  String logo = "assets/images/Stocker_blue_transpN.png";
  Color theme1 = Colors.black;
  Color theme2 = const Color(0xFF0080d9);

  String nomeNS = "";
  bool alteraTela = true;

  changeTheme() {
    isDarkTheme = !isDarkTheme;
    if (isDarkTheme) {
      background = "assets/images/back2B.jpg";
      logo = "assets/images/Stocker_blue_transpNB.png";
      theme1 = Colors.white;
      theme2 = const Color(0xFF710a9f);
    } else {
      background = "assets/images/back2.jpg";
      logo = "assets/images/Stocker_blue_transpN.png";
      theme1 = Colors.black;
      theme2 = const Color(0xFF0080d9);
    }
    notifyListeners();
  }
}
