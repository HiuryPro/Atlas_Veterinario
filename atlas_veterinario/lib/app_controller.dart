import 'package:atlas_veterinario/vetthemes.dart';
import 'package:flutter/material.dart';

class AppController extends ChangeNotifier {
  static AppController instance = AppController();

  VetThemes temas = VetThemes();

  bool isDarkTheme = false;
  ThemeData? temaEmUso;
  bool isTema = false;
  Color theme1 = Colors.black;
  Color theme2 = Colors.white;

  changeTheme() {
    isDarkTheme = !isDarkTheme;
    if (isDarkTheme) {
      theme1 = Colors.white;
      theme2 = Colors.black;
    } else {
      theme1 = Colors.black;
      theme2 = Colors.white;
    }
    notifyListeners();
  }

  ativaTema() {
    isTema = true;
    notifyListeners();
  }

  desativaTema() {
    isTema = false;
    notifyListeners();
  }

  CorVerde() {
    temaEmUso = temas.temaVerde();
    notifyListeners();
  }
}
