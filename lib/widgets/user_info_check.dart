import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/constants/assets_path.dart';
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
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(top: 28.h),
            child: Text(text,
                style: Theme.of(context)
                    .textTheme
                    .bigHeadLine3
                    .copyWith(color: ColorSchemes.gray500)),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 26.h),
            child: SizedBox(
              width: 28.r,
              height: 28.r,
              child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onPressed,
                  icon: SvgPicture.asset(IconPath.close, fit: BoxFit.scaleDown)),
            ),
          )
        ],
      ),
    );
  }
}