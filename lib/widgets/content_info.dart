import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';

class ContentInfo extends StatelessWidget {
  final String info;
  final VoidCallback? onPressed;
  final String icon;

  const ContentInfo({
    Key? key,
    required this.info,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 361.w,
      height: 24.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset('assets/icons/Rectangle 97.svg'),
              Text(
                  info,
                  style: Theme.of(context)
                      .textTheme
                      .body2
                      .copyWith(color: ColorSchemes.orange100 )),
            ],
          ),
          IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: onPressed,
              icon: SvgPicture.asset('assets/icons/dd')),
        ],
      ),
    );
  }
}
