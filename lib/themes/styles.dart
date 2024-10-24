import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  static AppBarTheme kAppAppBarTheme = AppBarTheme(
    color: Colors.white,
    scrolledUnderElevation: 0,
    titleSpacing: 16.w,
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
  TextStyle get bigHeadLine1 => TextStyle(
      letterSpacing: -1.5.sp,
      fontSize: 38.sp,
      fontVariations: const <FontVariation>[
        FontVariation('wght', 700),]);
  TextStyle get bigHeadLine2 => TextStyle(
      letterSpacing: -1.5.sp,
      fontSize: 32.sp,
      fontVariations: const <FontVariation>[
        FontVariation('wght', 700),]);
  TextStyle get bigHeadLine3 => TextStyle(
      letterSpacing: -0.5.sp,
      fontSize: 24.sp,
      fontVariations: const <FontVariation>[
        FontVariation('wght', 700),]);
  TextStyle get bigHeadLine4 => TextStyle(
      letterSpacing: -0.5.sp,
      fontSize: 20.sp,
      fontVariations: const <FontVariation>[
        FontVariation('wght', 700),]);
  TextStyle get bigHeadLine5 => TextStyle(
      letterSpacing: -0.5.sp,
      fontSize: 16.sp,
      fontVariations: const <FontVariation>[
        FontVariation('wght', 700),]);

  ///smallHeadLine
  TextStyle get smallHeadLine1 => TextStyle(
      letterSpacing: 0.25.sp,
      fontSize: 20.sp,
      fontVariations: const <FontVariation>[
        FontVariation('wght', 600),]);
  TextStyle get smallHeadLine2 => TextStyle(
      letterSpacing: 0.25.sp,
      fontSize: 18.sp,
      fontVariations: const <FontVariation>[
        FontVariation('wght', 600),]);
  TextStyle get smallHeadLine3 => TextStyle(
      letterSpacing: 0.25.sp,
      fontSize: 16.sp,
      fontVariations: const <FontVariation>[
        FontVariation('wght', 600),]);

  ///body
  TextStyle get body1 => TextStyle(
      letterSpacing: 1.25.sp,
      fontSize: 18.sp,
      fontVariations: const <FontVariation>[
        FontVariation('wght', 500),]);
  TextStyle get body2 => TextStyle(
      letterSpacing: 1.25.sp,
      fontSize: 16.sp,
      fontVariations: const <FontVariation>[
        FontVariation('wght', 500),]);
  TextStyle get body3 => TextStyle(
      letterSpacing: 1.25.sp,
      fontSize: 14.sp,
      fontVariations: const <FontVariation>[
        FontVariation('wght', 500),]);

  ///caption
  TextStyle get caption => TextStyle(
      letterSpacing: 1.25.sp,
      fontSize: 14.sp,
      fontVariations: const <FontVariation>[
        FontVariation('wght', 400),]);
}
