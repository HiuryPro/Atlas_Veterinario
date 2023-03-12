import 'package:flutter/material.dart';

class VetThemes {
  temaVerde() {
    return ThemeData(
        brightness: Brightness.light,
        inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
            focusColor: Color(0xff026534),
            prefixIconColor: Color(0xff026534),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                borderSide: BorderSide(color: Color(0xff026534), width: 1))),
        primaryColor: const Color(0xff026534),
        primaryColorLight: const Color(0xff026534),
        primaryColorDark: const Color(0xff026534),
        scaffoldBackgroundColor: const Color(0xff6fb43d),
        drawerTheme: const DrawerThemeData(
            surfaceTintColor: Color(0xff6fb43d),
            backgroundColor: Color(0xff6fb43d)),
        shadowColor: const Color(0xff6fb43d),
        bottomSheetTheme:
            const BottomSheetThemeData(backgroundColor: Color(0xff6fb43d)),
        sliderTheme: const SliderThemeData(
          activeTrackColor: Color(0xff026534),
          inactiveTrackColor: Color(0xff026534),
          thumbColor: Color(0xff026534),
          overlayColor: Color(0xff026534),
        ));
  }

  ThemeData loginCad() {
    return ThemeData(
      brightness: Brightness.light,
      inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          focusColor: Colors.black,
          prefixIconColor: Colors.black,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF2196f3), width: 2))),
    );
  }
}
