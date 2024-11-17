import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/main.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';

class AlertListTile extends StatelessWidget {
  final String title;
  final String content;
  final String iconName;
  final String time;

  const AlertListTile(
      {Key? key,
      required this.title,
      required this.content,
      required this.iconName,
      required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 18.h, 12.w, 9.h),
      decoration: BoxDecoration(
          color: ColorSchemes.white,
          borderRadius: BorderRadius.circular(StyleConstants.radiusMedium)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: StyleConstants.circleSizeXXS,
            backgroundColor: ColorSchemes.gray100,

            ///이미지 영역
          ),
          SizedBox(
            width: 6.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .bigHeadLine5
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
              SizedBox(
                height: 4.h,
              ),
              Text(content,
                  style: Theme.of(context)
                  .textTheme
                  .body2
                  .copyWith(color: ColorSchemes.gray400),),
              SizedBox(
                height: 8.h,
              ),
              Text(time,
                style: Theme.of(context)
                    .textTheme
                    .body3
                    .copyWith(color: ColorSchemes.gray200),),
            ],
          )
        ],
      ),
    );
  }
}
