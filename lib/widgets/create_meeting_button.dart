import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';

class CreateMeetingButton extends StatelessWidget {
  final String type;
  final String content;
  final VoidCallback? onPressed;
  final String icon;
  final Color typeColor;
  final Color contentColor;
  final String arrowIcon;
  final double? iconWidth;
  final double? iconHeight;

  const CreateMeetingButton({
    Key? key,
    required this.type,
    required this.content,
    required this.onPressed,
    required this.icon,
    required this.typeColor,
    required this.contentColor,
    required this.arrowIcon,
    this.iconWidth,
    this.iconHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14), color: Colors.white),
        padding: EdgeInsets.fromLTRB(12.w, 15.h, 16.w, 15.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 32.r,
                  height: 32.r,
                  child: Center(
                    child: SvgPicture.asset(
                      icon,
                      width: iconWidth,
                      height: iconHeight,
                      fit: BoxFit.scaleDown,// 원하는 아이콘 크기// 부모 크기와 관계없이 아이콘 크기 고정
                    ),
                  ),
                ),
                SizedBox(
                  width: 2.w,
                ),
                Text(
                  type,
                  style: Theme.of(context)
                      .textTheme
                      .smallHeadLine2
                      .copyWith(color: typeColor),
                ),
                SizedBox(width: 42.w,)
              ],
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      content,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .smallHeadLine3
                          .copyWith(color: contentColor),
                    ),
                  ),
                  SizedBox(width: 11.w),
                  SvgPicture.asset(arrowIcon, width: 8.r),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
