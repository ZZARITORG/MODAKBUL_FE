import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'skeleton_loader.dart';

class BlockedUserScreenSkeleton extends StatelessWidget {
  const BlockedUserScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSchemes.gray000,
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 26.h),
            Text(
              '차단된 사용자',
              style: Theme.of(context)
                  .textTheme
                  .body2
                  .copyWith(color: ColorSchemes.gray200),
            ),
            SizedBox(height: 34.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SkeletonLoader(
                        width: 64.r,
                        height: 64.r,
                        borderRadius: BorderRadius.circular(64.r)),
                    SizedBox(width: 8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonLoader(
                            width: 99.w,
                            height: 16.h,
                            borderRadius: BorderRadius.circular(
                                StyleConstants.radiusMedium)),
                        SizedBox(height: 10.h),
                        SkeletonLoader(
                            width: 111.w,
                            height: 14.h,
                            borderRadius: BorderRadius.circular(
                                StyleConstants.radiusMedium)),
                      ],
                    )
                  ],
                ),
                SkeletonLoader(
                    width: 81.w,
                    height: 34.h,
                    borderRadius:
                        BorderRadius.circular(StyleConstants.radiusMedium))
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SkeletonLoader(
                        width: 64.r,
                        height: 64.r,
                        borderRadius: BorderRadius.circular(64.r)),
                    SizedBox(width: 8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonLoader(
                            width: 99.w,
                            height: 16.h,
                            borderRadius: BorderRadius.circular(
                                StyleConstants.radiusMedium)),
                        SizedBox(height: 10.h),
                        SkeletonLoader(
                            width: 111.w,
                            height: 14.h,
                            borderRadius: BorderRadius.circular(
                                StyleConstants.radiusMedium)),
                      ],
                    )
                  ],
                ),
                SkeletonLoader(
                    width: 81.w,
                    height: 34.h,
                    borderRadius:
                        BorderRadius.circular(StyleConstants.radiusMedium))
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SkeletonLoader(
                        width: 64.r,
                        height: 64.r,
                        borderRadius: BorderRadius.circular(64.r)),
                    SizedBox(width: 8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonLoader(
                            width: 99.w,
                            height: 16.h,
                            borderRadius: BorderRadius.circular(
                                StyleConstants.radiusMedium)),
                        SizedBox(height: 10.h),
                        SkeletonLoader(
                            width: 111.w,
                            height: 14.h,
                            borderRadius: BorderRadius.circular(
                                StyleConstants.radiusMedium)),
                      ],
                    )
                  ],
                ),
                SkeletonLoader(
                    width: 81.w,
                    height: 34.h,
                    borderRadius:
                        BorderRadius.circular(StyleConstants.radiusMedium))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
