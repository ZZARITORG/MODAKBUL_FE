import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/styles.dart';

import '../themes/color_schemes.dart';

class MyModakbulListTile extends StatelessWidget {
  final String title;
  final String time;
  final String? profileImage1;
  final String? profileImage2;
  final int profileLength;

  const MyModakbulListTile(
      {Key? key,
      required this.title,
      required this.time,
      this.profileImage1,
      this.profileImage2,
      required this.profileLength})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(StyleConstants.radiusMedium),
      ),
      color: ColorSchemes.orange000,

      ///clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.fromLTRB(18.w, 8.h, 18.w, 42.h),
        child: Column(
          children: [
            SizedBox(
              height: 24.h,
              width: 24.w,
              child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: (){},
                  icon: SvgPicture.asset('아이콘 경로')),
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 200.w,
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .smallHeadLine1
                              .copyWith(color: ColorSchemes.gray500),
                        )),
                    SizedBox(
                      height: 8.h,
                    ),
                    Text(
                      time,
                      style: Theme.of(context)
                          .textTheme
                          .body3
                          .copyWith(color: ColorSchemes.orange200),
                    ),
                  ],
                ),
                SizedBox(
                  width: 98.w,
                  child: Stack(
                    children: [
                      if (profileLength >= 1)
                        Positioned(
                            child: CircleAvatar(
                          radius: StyleConstants.circleSizeXS,
                          backgroundColor: ColorSchemes.white,
                          child: CircleAvatar(
                            radius: StyleConstants.circleSizeXXXS,
                            backgroundColor: ColorSchemes.orange200,
                          ),
                        )),
                      if (profileLength >= 2)
                        Positioned(
                            left: 28.w,
                            child: CircleAvatar(
                              radius: StyleConstants.circleSizeXS,
                              backgroundColor: ColorSchemes.white,
                              child: CircleAvatar(
                                radius: StyleConstants.circleSizeXXXS,
                                backgroundColor: ColorSchemes.orange100,
                              ),
                            )),
                      if (profileLength >= 3)
                        Positioned(
                            left: 56.w,
                            child: CircleAvatar(
                              radius: StyleConstants.circleSizeXS,
                              backgroundColor: ColorSchemes.white,
                              child: CircleAvatar(
                                radius: StyleConstants.circleSizeXXXS,
                                backgroundColor: ColorSchemes.gray300,
                                child: Text(
                                  '+${profileLength - 2}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .body3
                                      .copyWith(color: ColorSchemes.white),
                                ),
                              ),
                            )),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
