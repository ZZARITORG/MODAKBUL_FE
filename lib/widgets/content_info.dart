import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/constants/assets_path.dart';
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
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                  width: 24.r,
                  height: 24.r,
                  child: SvgPicture.asset(icon, fit: BoxFit.scaleDown)),
              SizedBox(
                  width: 2.w
              ),
              Text(
                  info,
                  style: Theme.of(context)
                      .textTheme
                      .body2
                      .copyWith(color: ColorSchemes.orange100)),
            ],
          ),
          SvgPicture.asset(IconPath.arrowForward15Orange200),
        ],
      ),
    );
  }
}
