import 'package:flutter/material.dart';

import 'color_schemes.dart';

class Styles {
  ///테마 상수화
  static ThemeData themeData = ThemeData(
    primaryColor: ColorSchemes.orange200,
    textTheme: textTheme,
    fontFamily: 'PretendardVariable',
  );

  static TextTheme textTheme = TextTheme(
  );
}

extension CustomStyles on TextTheme {
  TextStyle get bigHeadLine1 => const TextStyle(
      fontSize: 38.0, fontWeight: FontWeight.w700, letterSpacing: -1.5);
  TextStyle get bigHeadLine2 => const TextStyle(
      fontSize: 32.0, fontWeight: FontWeight.w700, letterSpacing: -1.5);
  TextStyle get bigHeadLine3 => const TextStyle(
      fontSize: 24.0, fontWeight: FontWeight.w700, letterSpacing: -0.5);
  TextStyle get bigHeadLine4 => const TextStyle(
      fontSize: 20.0, fontWeight: FontWeight.w700, letterSpacing: -0.5);
  TextStyle get bigHeadLine5 => const TextStyle(
      fontSize: 16.0, fontWeight: FontWeight.w700, letterSpacing: -0.5);

  TextStyle get smallHeadLine1 => const TextStyle(
      fontSize: 20.0, fontWeight: FontWeight.w600, letterSpacing: 0.25);
  TextStyle get smallHeadLine2 => const TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.w600, letterSpacing: 0.25);
  TextStyle get smallHeadLine3 => const TextStyle(
      fontSize: 16.0, fontWeight: FontWeight.w600, letterSpacing: 0.25);

  TextStyle get body1 => const TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.w500, letterSpacing: 1.25);
  TextStyle get body2 => const TextStyle(
      fontSize: 16.0, fontWeight: FontWeight.w500, letterSpacing: 1.25);
  TextStyle get body3 => const TextStyle(
      fontSize: 14.0, fontWeight: FontWeight.w500, letterSpacing: 1.25);

  TextStyle get caption => const TextStyle(
      fontSize: 14.0, fontWeight: FontWeight.w400, letterSpacing: 1.25);
}
