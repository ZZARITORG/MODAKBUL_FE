import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'skeleton_loader.dart';

class ModakbulMapScreenSkeleton extends StatelessWidget {
  const ModakbulMapScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSchemes.gray000,
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 32.h, 0.w, 28.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonLoader(
                width: 286.w,
                height: 38.h,
                borderRadius:
                    BorderRadius.circular(StyleConstants.radiusMedium)),
            SizedBox(height: 10.h),
            SkeletonLoader(
                width: 170.w,
                height: 38.h,
                borderRadius:
                    BorderRadius.circular(StyleConstants.radiusMedium)),
            SizedBox(height: 20.h),
            SkeletonLoader(
                width: 347.w,
                height: 16.h,
                borderRadius:
                    BorderRadius.circular(StyleConstants.radiusMedium)),
          ],
        ),
      ),
    );
  }
}
