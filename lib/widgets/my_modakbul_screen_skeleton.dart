import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'skeleton_loader.dart';

class MyModakbulScreenSkeleton extends StatelessWidget {
  const MyModakbulScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSchemes.gray000,
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 32.h, 16.w, 0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonLoader(
                width: 286.w,
                height: 37.h,
                borderRadius:
                    BorderRadius.circular(StyleConstants.radiusMedium)),
            SizedBox(height: 6.h),
            SkeletonLoader(
                width: 172.w,
                height: 37.h,
                borderRadius:
                    BorderRadius.circular(StyleConstants.radiusMedium)),
            SizedBox(height: 12.h),
            SkeletonLoader(
                width: 286.w,
                height: 24.h,
                borderRadius:
                    BorderRadius.circular(StyleConstants.radiusMedium)),
            SizedBox(height: 24.h),
            SkeletonLoader(
                width: 361.w,
                height: 105.h,
                borderRadius:
                    BorderRadius.circular(StyleConstants.radiusMedium)),
            SizedBox(height: 14),
            SkeletonLoader(
                width: 361.w,
                height: 105.h,
                borderRadius:
                    BorderRadius.circular(StyleConstants.radiusMedium))
          ],
        ),
      ),
    );
  }
}
