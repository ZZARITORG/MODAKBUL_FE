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
  final double? iconHeight;
  final double? iconWidth;
  final bool isActivated;

  const ContentInfo(
      {Key? key,
        required this.info,
        required this.onPressed,
        required this.icon,
        required this.isActivated,
        this.iconHeight,
        this.iconWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                SizedBox(
                    width: 24.r,
                    height: 24.r,
                    child: Center(
                        child: SvgPicture.asset(
                          icon,
                          width: iconWidth,
                          height: iconHeight,
                        ))),
                SizedBox(width: 2.w),
                Flexible(
                  child: Text(info,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .body2
                          .copyWith(color: isActivated ? ColorSchemes.orange200 : ColorSchemes.orange100)),
                ),
              ],
            ),
          ),
          SizedBox(width: 6.w,),
          SizedBox(
            height: 24.r,
            width: 24.r,
            child: Center(
              child: SvgPicture.asset(
                isActivated ? IconPath.arrowForward15Orange200 : IconPath.arrowForward15Orange100,
                width: 8.r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
