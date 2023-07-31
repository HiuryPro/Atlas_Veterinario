import 'package:atlas_veterinario/Utils/vetthemes.dart';
import 'package:flutter/material.dart';

class AppController extends ChangeNotifier {
  static AppController instance = AppController();

  VetThemes temas = VetThemes();

  bool isDarkTheme = false;
  ThemeData? temaEmUso;
  bool isTema = false;
  bool isAdmin = false;
  Color theme1 = Colors.black;
  Color theme2 = Colors.white;
  Color themeCustom = Colors.white;
  Color themeCustom2 = Colors.white;

  int tamanhoFonte = 12;
  int totalPaginas = 2017;

  String email = '';
  String senha = '';
  String nome = '';

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

  corVerde() {
    temaEmUso = temas.temaVerde();
    themeCustom = const Color(0xff6fb43d);
    themeCustom2 = const Color(0xff026534);
    notifyListeners();
  }
}
