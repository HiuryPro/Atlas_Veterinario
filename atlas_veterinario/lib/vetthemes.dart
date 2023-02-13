import 'package:flutter/material.dart';

class VetThemes {
  temaVerde() {
    return ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xff6fb43d),
        sliderTheme: const SliderThemeData(
          activeTrackColor: Color(0xff026534),
          inactiveTrackColor: Color(0xff026534),
          thumbColor: Color(0xff026534),
          overlayColor: Color(0xff026534),
        ));
  }
}
