import 'package:flutter/material.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'skeleton_loader.dart';

class HomeScreenSkeleton extends StatelessWidget {
  const HomeScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(StyleConstants.radiusMedium)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                  children: [
                SkeletonLoader(width: 181.w, height: 24.h),
                SizedBox(height: 12.h),
                SkeletonLoader(width: 130.w, height: 14.h)
              ])
            ],
          ),
          SkeletonLoader(width: 75.r, height: 75.r)
        ],
      ),
    );
  }
}
