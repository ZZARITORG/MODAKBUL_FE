import 'package:flutter/material.dart';

import 'color_schemes.dart';

class Styles {
  ///테마 상수화
  static ThemeData themeData = ThemeData(
    primaryColor: ColorSchemes.orange200,
    textTheme: textTheme,
  );

  static TextTheme textTheme = TextTheme(
  );
}

extension CustomStyles on TextTheme {
  TextStyle get hello => const TextStyle(
      fontSize: 20.0, color: Colors.blue, fontWeight: FontWeight.bold);
}
