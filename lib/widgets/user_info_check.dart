import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';

class UserInfoCheck extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const UserInfoCheck({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 363.w,
      height: 54.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(top: 26.h),
            child: Text(text,
                style: Theme.of(context)
                    .textTheme
                    .bigHeadLine3
                    .copyWith(color: ColorSchemes.gray500)),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 26.h),
            child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onPressed,
                icon: SvgPicture.asset('assets/icons/Rectangle 97.svg')),
          )
        ],
      ),
    );
  }
}