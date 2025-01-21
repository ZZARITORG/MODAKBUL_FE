import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/style_constants.dart';
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
      iconButtonTheme: kIconButtonThemeData,
      textButtonTheme: kTextButtonThemeData,
      dialogTheme: kDialogTheme,
      useMaterial3: true,
      bottomNavigationBarTheme: kBottomNavigationBarThemeData);

  ///Appbar 테마
  static AppBarTheme kAppAppBarTheme = AppBarTheme(
    color: Colors.white,
    scrolledUnderElevation: 0,
    titleSpacing: StyleConstants.defaultPadding,
  );

  ///BottomSheet 테마
  static BottomSheetThemeData kBottomSheetThemeData = BottomSheetThemeData(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(StyleConstants.radiusLarge))),
    backgroundColor: ColorSchemes.white,
  );

  ///ElevatedButton 테마
  static ElevatedButtonThemeData kElevatedButtonThemeData =
      ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
    minimumSize: Size.zero,
    padding: EdgeInsets.zero,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    elevation: 0,
    overlayColor: ColorSchemes.orange100,
    shadowColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(StyleConstants.radiusMedium),
    ),
  ));

  ///IconButton 테마
  static IconButtonThemeData kIconButtonThemeData = const IconButtonThemeData(
    style: ButtonStyle(
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
  );

  ///TextButton 테마
  static TextButtonThemeData kTextButtonThemeData = TextButtonThemeData(
    style: TextButton.styleFrom(
      minimumSize: Size.zero,
      padding: EdgeInsets.zero,
      overlayColor: ColorSchemes.orange100,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
  );

  ///Dialog 테마
  static DialogTheme kDialogTheme = DialogTheme(
      backgroundColor: ColorSchemes.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(StyleConstants.radiusMedium))));

  static BottomNavigationBarThemeData kBottomNavigationBarThemeData =
      BottomNavigationBarThemeData(
          elevation: 0, backgroundColor: ColorSchemes.white);

/** static TextTheme textTheme = TextTheme(
    ); */
}

///CustomTextStyles
extension CustomStyles on TextTheme {
  /// bigHeadLine
  TextStyle get bigHeadLine1 => TextStyle(
        letterSpacing: (38.sp * -1.5 / 100).w,
        height: 60 / 38,
        fontSize: 38.sp,
        fontVariations: const <FontVariation>[
          FontVariation('wght', 700),
        ],
      );

  TextStyle get bigHeadLine2 => TextStyle(
        letterSpacing: (32.sp * -1.5 / 100).w,
        height: 42 / 32,
        fontSize: 32.sp,
        fontVariations: const <FontVariation>[
          FontVariation('wght', 700),
        ],
      );

  TextStyle get bigHeadLine3 => TextStyle(
        letterSpacing: (22.sp * -0.5 / 100).w,
        height: 26.25 / 22,
        fontSize: 22.sp,
        fontVariations: const <FontVariation>[
          FontVariation('wght', 700),
        ],
      );

  TextStyle get bigHeadLine4 => TextStyle(
        letterSpacing: (20.sp * -0.5 / 100).w,
        height: 23.87 / 20,
        fontSize: 20.sp,
        fontVariations: const <FontVariation>[
          FontVariation('wght', 700),
        ],
      );

  TextStyle get bigHeadLine5 => TextStyle(
        letterSpacing: (16.sp * -0.5 / 100).w,
        height: 19.09 / 16,
        fontSize: 16.sp,
        fontVariations: const <FontVariation>[
          FontVariation('wght', 700),
        ],
      );

  /// smallHeadLine
  TextStyle get smallHeadLine1 => TextStyle(
        letterSpacing: (20.sp * 0.25 / 100).w,
        fontSize: 20.sp,
        height: 23.87 / 20,
        fontVariations: const <FontVariation>[
          FontVariation('wght', 600),
        ],
      );

  TextStyle get smallHeadLine2 => TextStyle(
        letterSpacing: (18.sp * 0.25 / 100).w,
        height: 21.48 / 18,
        fontSize: 18.sp,
        fontVariations: const <FontVariation>[
          FontVariation('wght', 600),
        ],
      );

  TextStyle get smallHeadLine3 => TextStyle(
        letterSpacing: (16.sp * 0.25 / 100).w,
        height: 19.09 / 16,
        fontSize: 16.sp,
        fontVariations: const <FontVariation>[
          FontVariation('wght', 600),
        ],
      );

  /// body
  TextStyle get body1 => TextStyle(
        letterSpacing: (18.sp * 1.25 / 100).w,
        fontSize: 18.sp,
        height: 21.48 / 18,
        fontVariations: const <FontVariation>[
          FontVariation('wght', 500),
        ],
      );

  TextStyle get body2 => TextStyle(
        letterSpacing: (16.sp * 1.25 / 100).w,
        height: 24 / 16,
        fontSize: 16.sp,
        fontVariations: const <FontVariation>[
          FontVariation('wght', 500),
        ],
      );

  TextStyle get body3 => TextStyle(
        letterSpacing: (14.sp * 1.25 / 100).w,
        height: 22 / 14,
        fontSize: 14.sp,
        fontVariations: const <FontVariation>[
          FontVariation('wght', 500),
        ],
      );

  /// caption
  TextStyle get caption => TextStyle(
        letterSpacing: (14.sp * 1.25 / 100).w,
        height: 16.71 / 14,
        fontSize: 14.sp,
        fontVariations: const <FontVariation>[
          FontVariation('wght', 400),
        ],
      );
}
