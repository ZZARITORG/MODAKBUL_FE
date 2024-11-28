import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/styles.dart';
import '../themes/color_schemes.dart';

class MyModakbulCard extends StatelessWidget {
  final String? profileImage1;
  final String? profileImage2;
  final int profileLength;
  final String title;
  final String group;
  final String date;
  final String location;

  const MyModakbulCard({
    Key? key,
    this.profileImage1,
    this.profileImage2,
    required this.profileLength,
    required this.title,
    required this.group,
    required this.date,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          group,
          style: Theme.of(context)
              .textTheme
              .body3
              .copyWith(color: ColorSchemes.orange200),
        ),
        SizedBox(
          height: 4.h,
        ),
        FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bigHeadLine3
                .copyWith(color: ColorSchemes.gray500),
          ),
        ),
        SizedBox(height: 18.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 16.r,
              height: 16.r,
              child: SvgPicture.asset(
                IconPath.timeOrange100,
                width: 16.r,
              ),
            ),
            SizedBox(
              width: 4.w,
            ),
            Text(
              date,
              style: Theme.of(context)
                  .textTheme
                  .body3
                  .copyWith(color: ColorSchemes.orange100),
            )
          ],
        ),
        SizedBox(
          height: 6.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 16.r,
              height: 16.r,
              child: SvgPicture.asset(
                IconPath.pinDropOrange100,
                width: 16.r,
              ),
            ),
            SizedBox(
              width: 4.w,
            ),
            Text(
              location,
              style: Theme.of(context)
                  .textTheme
                  .body3
                  .copyWith(color: ColorSchemes.orange100),
            ),
          ],
        ),
        SizedBox(
          height: 15.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  color: ColorSchemes.orange200),
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
              child: Text(
                '내가 피운 모닥불',
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: ColorSchemes.white),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  profileLength == 1
                      ? Row(
                          children: [
                            Text(
                              '참여자가 없습니다',
                              style: Theme.of(context).textTheme.body3.copyWith(
                                  color: ColorSchemes.gray200, height: 1.571),
                            ),
                            SizedBox(width: 6.w),
                            SvgPicture.asset(IconPath.arrowForward15Gray200,
                                width: 8.r),
                          ],
                        )
                      : Row(
                          children: [
                            SizedBox(
                              width: profileLength >= 4
                                  ? 84.w
                                  : (profileLength == 3 ? 60.w : 36.w),
                              child: Stack(
                                children: [
                                  if (profileLength >= 2)
                                    Positioned(
                                      child: CircleAvatar(
                                        radius: StyleConstants.circleSizeXXXXXS,
                                        backgroundColor: ColorSchemes.white,
                                        child: CircleAvatar(
                                          radius:
                                              StyleConstants.circleSizeXXXXXXS,
                                          backgroundColor:
                                              ColorSchemes.orange200,
                                        ),
                                      ),
                                    ),
                                  if (profileLength >= 3)
                                    Positioned(
                                      left: 24.w,
                                      child: CircleAvatar(
                                        radius: StyleConstants.circleSizeXXXXXS,
                                        backgroundColor: ColorSchemes.white,
                                        child: CircleAvatar(
                                          radius:
                                              StyleConstants.circleSizeXXXXXXS,
                                          backgroundColor:
                                              ColorSchemes.orange100,
                                        ),
                                      ),
                                    ),
                                  if (profileLength >= 4)
                                    Positioned(
                                      left: 48.w,
                                      child: CircleAvatar(
                                        radius: StyleConstants.circleSizeXXXXXS,
                                        backgroundColor: ColorSchemes.white,
                                        child: CircleAvatar(
                                          radius:
                                              StyleConstants.circleSizeXXXXXXS,
                                          backgroundColor:
                                              ColorSchemes.orange000,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(width: 7.w),
                            Text(
                              '${profileLength - 1}명',
                              style: Theme.of(context).textTheme.body3.copyWith(
                                  color: ColorSchemes.gray200),
                            ),
                            SizedBox(width: 6.w),
                            SvgPicture.asset(IconPath.arrowForward15Gray200,
                                width: 8.r),
                          ],
                        ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
