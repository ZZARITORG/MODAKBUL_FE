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
  final TextEditingController controller;
  final FocusNode? focusNode;

  const CustomSearchBar(
      {Key? key,
        required this.hintText,
        required this.controller,
        this.focusNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextField(
          controller: controller,
          focusNode: focusNode,
          style: Theme.of(context)
              .textTheme
              .body1
              .copyWith(color: ColorSchemes.gray500),
          cursorColor: Theme.of(context).primaryColorLight,
          //바뀔 수도 있음
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 13.h),
            prefixIcon: Padding(
              padding: EdgeInsets.only(
                  left: 14.w, right: 4.w),
              child: SizedBox(
                height: 24.r,
                width: 24.r,
                child: Center(
                  child: SvgPicture.asset(
                    IconPath.search,
                    width: 17.r,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            ),
            prefixIconConstraints: BoxConstraints(
              minWidth: 24.r,
              minHeight: 24.r,
            ),
            hintText: hintText,
            hintStyle: Theme.of(context)
                .textTheme
                .body1
                .copyWith(color: ColorSchemes.gray200),
            isDense: true,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius:
                BorderRadius.circular(StyleConstants.radiusMedium)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius:
                BorderRadius.circular(StyleConstants.radiusMedium)),
            filled: true,
            fillColor: ColorSchemes.gray100,

            ///suffixIcon: 추후 x아이콘
          )),
    );
  }
}
