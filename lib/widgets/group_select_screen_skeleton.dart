import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'skeleton_loader.dart';

class GroupSelectScreenSkeleton extends StatelessWidget {
  const GroupSelectScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSchemes.gray000,
      body: Column(
        children: [
          SizedBox(height: 58.h), // 앱바 영역 나중에 수정 예정
          SizedBox(height: 10.h),
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0.h),
                  child: Card(
                      color: ColorSchemes.white,
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              StyleConstants.radiusMedium)),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(18.w, 18.h, 16.w, 45.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              SizedBox(width: 305.w),
                              SkeletonLoader(
                                  width: 4.r,
                                  height: 4.r,
                                  borderRadius: BorderRadius.circular(4)),
                              SizedBox(width: 4.w),
                              SkeletonLoader(
                                  width: 4.r,
                                  height: 4.r,
                                  borderRadius: BorderRadius.circular(4)),
                              SizedBox(width: 4.w),
                              SkeletonLoader(
                                  width: 4.r,
                                  height: 4.r,
                                  borderRadius: BorderRadius.circular(4))
                            ]),
                            SizedBox(height: 20.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SkeletonLoader(
                                        width: 202.w,
                                        height: 24.h,
                                        borderRadius: BorderRadius.circular(
                                            StyleConstants.radiusMedium)),
                                    SizedBox(height: 8.h),
                                    SkeletonLoader(
                                        width: 167.w,
                                        height: 14.h,
                                        borderRadius: BorderRadius.circular(
                                            StyleConstants.radiusMedium)),
                                  ],
                                ),
                                SizedBox(width: 27.w),
                                SizedBox(
                                  width: 98.w,
                                  child: Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: StyleConstants.circleSizeXXS,
                                        backgroundColor: Colors.white,
                                        child: SkeletonLoader(
                                            width: 38.r,
                                            height: 38.r,
                                            borderRadius:
                                                BorderRadius.circular(38)),
                                      ),
                                      Positioned(
                                          left: 28.w,
                                          child: CircleAvatar(
                                            radius:
                                                StyleConstants.circleSizeXXS,
                                            backgroundColor: Colors.white,
                                            child: SkeletonLoader(
                                                width: 38.r,
                                                height: 38.r,
                                                borderRadius:
                                                    BorderRadius.circular(38)),
                                          )),
                                      Positioned(
                                          left: 56.w,
                                          child: CircleAvatar(
                                            radius:
                                                StyleConstants.circleSizeXXS,
                                            backgroundColor: Colors.white,
                                            child: SkeletonLoader(
                                                width: 38.r,
                                                height: 38.r,
                                                borderRadius:
                                                    BorderRadius.circular(38)),
                                          ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      )),
                );
              }),
        ],
      ),
    );
  }
}
