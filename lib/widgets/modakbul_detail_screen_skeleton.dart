import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'skeleton_loader.dart';

class ModakbulDetailScreenSkeleton extends StatelessWidget {
  const ModakbulDetailScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSchemes.gray000,
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 11.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SkeletonLoader(
                          width: 42.r,
                          height: 42.r,
                          borderRadius: BorderRadius.circular(42)),
                      SizedBox(width: 4.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonLoader(
                              width: 42.w,
                              height: 18.h,
                              borderRadius: BorderRadius.circular(
                                  StyleConstants.radiusSmall)),
                          SizedBox(height: 3.h),
                          SkeletonLoader(
                              width: 58.w,
                              height: 14.h,
                              borderRadius: BorderRadius.circular(
                                  StyleConstants.radiusSmall))
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 60.w,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: StyleConstants.circleSizeXXXXXS,
                              backgroundColor: Colors.white,
                              child: SkeletonLoader(
                                  width: 32.r,
                                  height: 32.r,
                                  borderRadius: BorderRadius.circular(32)),
                            ),
                            Positioned(
                                left: 24.w,
                                child: CircleAvatar(
                                  radius: StyleConstants.circleSizeXXXXXS,
                                  backgroundColor: Colors.white,
                                  child: SkeletonLoader(
                                      width: 32.r,
                                      height: 32.r,
                                      borderRadius: BorderRadius.circular(32)),
                                ))
                          ],
                        ),
                      ),
                      SizedBox(width: 8.w),
                      SkeletonLoader(
                          width: 21.w,
                          height: 14.h,
                          borderRadius: BorderRadius.circular(
                              StyleConstants.radiusMedium))
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 36.h),
            Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: Row(
                children: [
                  SkeletonLoader(
                      width: 14.r,
                      height: 14.r,
                      borderRadius:
                          BorderRadius.circular(StyleConstants.radiusSmall)),
                  SizedBox(width: 10.w),
                  SkeletonLoader(
                      width: 99.w,
                      height: 14.h,
                      borderRadius:
                          BorderRadius.circular(StyleConstants.radiusMedium))
                ],
              ),
            ),
            SizedBox(height: 18.h),
            SkeletonLoader(
                width: 286.w,
                height: 24.h,
                borderRadius:
                    BorderRadius.circular(StyleConstants.radiusMedium)),
            SizedBox(height: 14.h),
            SkeletonLoader(
                width: 286.w,
                height: 14.h,
                borderRadius:
                    BorderRadius.circular(StyleConstants.radiusMedium)),
            SizedBox(height: 8.h),
            SkeletonLoader(
                width: 286.w,
                height: 14.h,
                borderRadius:
                    BorderRadius.circular(StyleConstants.radiusMedium)),
            SizedBox(height: 68.h),
            Padding(
              padding: EdgeInsets.fromLTRB(4.w, 0.h, 16.w, 0.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SkeletonLoader(
                      width: 35.w,
                      height: 24.h,
                      borderRadius:
                          BorderRadius.circular(StyleConstants.radiusMedium)),
                  SkeletonLoader(
                      width: 106.w,
                      height: 14.h,
                      borderRadius:
                          BorderRadius.circular(StyleConstants.radiusSmall))
                ],
              ),
            ),
            SizedBox(height: 14.h),
            SkeletonLoader(
                width: 361.w,
                height: 118.h,
                borderRadius:
                    BorderRadius.circular(StyleConstants.radiusMedium)),
            SizedBox(height: 14.h),
            Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: Row(
                children: [
                  SkeletonLoader(
                      width: 126.w,
                      height: 14.h,
                      borderRadius:
                          BorderRadius.circular(StyleConstants.radiusMedium)),
                  SizedBox(width: 10.w),
                  SkeletonLoader(
                      width: 37.w,
                      height: 14.h,
                      borderRadius:
                          BorderRadius.circular(StyleConstants.radiusMedium)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
