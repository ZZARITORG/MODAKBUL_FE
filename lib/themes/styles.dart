import 'package:flutter/material.dart';

import 'color_schemes.dart';

class Styles {
  ///App 테마
  static ThemeData kThemeData = ThemeData(
    primaryColor: ColorSchemes.orange200,
    primaryColorLight: ColorSchemes.orange100,
    cardColor: ColorSchemes.white,
    scaffoldBackgroundColor: ColorSchemes.white,

    ///textTheme: textTheme,
    fontFamily: 'PretendardVariable',
    appBarTheme: kAppAppBarTheme,
    bottomSheetTheme: kBottomSheetThemeData,
    elevatedButtonTheme: kElevatedButtonThemeData,
    useMaterial3: true,
  );

  ///Appbar 테마
  static AppBarTheme kAppAppBarTheme = const AppBarTheme(
    color: Colors.white,
    scrolledUnderElevation: 0,
    titleSpacing: 16, //여기 디폴트패딩 상수로 넣기
  );

  ///BottomSheet 테마
  static BottomSheetThemeData kBottomSheetThemeData =
      const BottomSheetThemeData(
    backgroundColor: ColorSchemes.white,
  );

  ///ElevatedButton 테마
  static ElevatedButtonThemeData kElevatedButtonThemeData =
      ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
    minimumSize: Size.zero,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    ),
  ));

/** static TextTheme textTheme = TextTheme(
    ); */
}

///CustomTextStyles
extension CustomStyles on TextTheme {

  ///bigHeadLine
  TextStyle get bigHeadLine1 => const TextStyle(
      letterSpacing: -1.5,
      fontSize: 38,
      fontVariations: <FontVariation>[
        FontVariation('wght', 700),]);
  TextStyle get bigHeadLine2 => const TextStyle(
      letterSpacing: -1.5,
      fontSize: 32,
      fontVariations: <FontVariation>[
        FontVariation('wght', 700),]);
  TextStyle get bigHeadLine3 => const TextStyle(
      letterSpacing: -0.5,
      fontSize: 24,
      fontVariations: <FontVariation>[
        FontVariation('wght', 700),]);
  TextStyle get bigHeadLine4 => const TextStyle(
      letterSpacing: -0.5,
      fontSize: 20,
      fontVariations: <FontVariation>[
        FontVariation('wght', 700),]);
  TextStyle get bigHeadLine5 => const TextStyle(
      letterSpacing: -0.5,
      fontSize: 16,
      fontVariations: <FontVariation>[
        FontVariation('wght', 700),]);

  ///smallHeadLine
  TextStyle get smallHeadLine1 => const TextStyle(
      letterSpacing: 0.25,
      fontSize: 20,
      fontVariations: <FontVariation>[
        FontVariation('wght', 600),]);
  TextStyle get smallHeadLine2 => const TextStyle(
      letterSpacing: 0.25,
      fontSize: 18,
      fontVariations: <FontVariation>[
        FontVariation('wght', 600),]);
  TextStyle get smallHeadLine3 => const TextStyle(
      letterSpacing: 0.25,
      fontSize: 16,
      fontVariations: <FontVariation>[
        FontVariation('wght', 600),]);

  ///body
  TextStyle get body1 => const TextStyle(
      letterSpacing: 1.25,
      fontSize: 18,
      fontVariations: <FontVariation>[
        FontVariation('wght', 500),]);
  TextStyle get body2 => const TextStyle(
      letterSpacing: 1.25,
      fontSize: 16,
      fontVariations: <FontVariation>[
        FontVariation('wght', 500),]);
  TextStyle get body3 => const TextStyle(
      letterSpacing: 1.25,
      fontSize: 14,
      fontVariations: <FontVariation>[
        FontVariation('wght', 500),]);

  ///caption
  TextStyle get caption => const TextStyle(
      letterSpacing: 1.25,
      fontSize: 14,
      fontVariations: <FontVariation>[
        FontVariation('wght', 400),]);
}
