import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/main.dart';
import 'package:modakbul/themes/styles.dart';

import '../themes/color_schemes.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;

  const CustomSearchBar({Key? key, required this.hintText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: TextField(
          style: Theme.of(context).textTheme.body1.copyWith(color: ColorSchemes.gray500),
          cursorColor: Theme.of(context).primaryColorLight, //바뀔 수도 있음
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 14.w, right: 4.w),
              child: SizedBox(
                height: 24.h,
                width: 24.w,
                child: SvgPicture.asset(
                  IconPath.search,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            prefixIconConstraints: BoxConstraints(
              minWidth: 24.w,
              minHeight: 24.h,
            ),
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.body1.copyWith(color: ColorSchemes.gray200),
            isDense: true,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(StyleConstants.radiusMedium)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(StyleConstants.radiusMedium)),
            filled: true,
            fillColor: ColorSchemes.gray100,
            ///suffixIcon: 추후 x아이콘
          )),
    );
  }
}
