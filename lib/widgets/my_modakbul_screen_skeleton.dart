import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'skeleton_loader.dart';

class MyModakbulScreenSkeleton extends StatelessWidget {
  const MyModakbulScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24.h),
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
            width: double.infinity,
            height: 105.h,
            borderRadius:
                BorderRadius.circular(StyleConstants.radiusMedium)),
        SizedBox(height: 14),
        SkeletonLoader(
            width: double.infinity,
            height: 105.h,
            borderRadius:
                BorderRadius.circular(StyleConstants.radiusMedium))
      ],
    );
  }
}
