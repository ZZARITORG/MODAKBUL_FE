import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/themes/color_schemes.dart';

class FixedModakbulCard extends StatelessWidget {
  final String title;
  final String date;
  final String location;

  const FixedModakbulCard({
    Key? key,
    required this.title,
    required this.date,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 285.w,
      child: Card(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(StyleConstants.radiusMedium),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(14.w, 24.h, 14.w, 18.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bigHeadLine4
                    .copyWith(color: ColorSchemes.gray400),
              ),
              SizedBox(height: 14.h),
              Row(
                children: [
                  SizedBox(
                    width: 20.r,
                    height: 20.r,
                    child: Center(
                      child: SvgPicture.asset(
                        IconPath.timeOrange100,
                        width: 16.r,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      date,
                      style: Theme.of(context)
                          .textTheme
                          .body3
                          .copyWith(color: ColorSchemes.orange001),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Row(
                children: [
                  SizedBox(
                    width: 20.r,
                    height: 20.r,
                    child: Center(
                      child: SvgPicture.asset(
                        IconPath.pinDropOrange100,
                        width: 12.r,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      location,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .body3
                          .copyWith(color: ColorSchemes.orange001),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}