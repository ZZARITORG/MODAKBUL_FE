import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'skeleton_loader.dart';

class PushScreenSkeleton extends StatelessWidget {
  const PushScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSchemes.gray000,
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0.h, 18.w, 0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 34.h),
            SkeletonLoader(
              width: 42.w,
              height: 24.h,
              borderRadius: BorderRadius.circular(StyleConstants.radiusSmall),
            ),
            SizedBox(height: 18.h),
            Card(
              color: ColorSchemes.gray100,
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  StyleConstants.radiusMedium,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(12.w, 18.h, 18.w, 14.h),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SkeletonLoader(
                          width: 40.r,
                          height: 40.r,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        SizedBox(width: 6.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SkeletonLoader(
                              width: 205.w,
                              height: 16.h,
                              borderRadius: BorderRadius.circular(
                                StyleConstants.radiusSmall,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            SkeletonLoader(
                              width: 283.w,
                              height: 14.h,
                              borderRadius: BorderRadius.circular(
                                StyleConstants.radiusSmall,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),
                    Row(
                      children: [
                        SizedBox(width: 46.w),
                        SkeletonLoader(
                          width: 87.w,
                          height: 14.h,
                          borderRadius: BorderRadius.circular(
                            StyleConstants.radiusSmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Card(
              color: ColorSchemes.gray100,
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  StyleConstants.radiusMedium,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(12.w, 18.h, 18.w, 14.h),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SkeletonLoader(
                          width: 40.r,
                          height: 40.r,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        SizedBox(width: 6.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SkeletonLoader(
                              width: 205.w,
                              height: 16.h,
                              borderRadius: BorderRadius.circular(
                                StyleConstants.radiusSmall,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            SkeletonLoader(
                              width: 283.w,
                              height: 14.h,
                              borderRadius: BorderRadius.circular(
                                StyleConstants.radiusSmall,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),
                    Row(
                      children: [
                        SizedBox(width: 46.w),
                        SkeletonLoader(
                          width: 87.w,
                          height: 14.h,
                          borderRadius: BorderRadius.circular(
                            StyleConstants.radiusSmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 28.h),
            SkeletonLoader(
              width: 42.w,
              height: 24.h,
              borderRadius: BorderRadius.circular(StyleConstants.radiusSmall),
            ),
            SizedBox(height: 18.h),
            Card(
              color: ColorSchemes.gray100,
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  StyleConstants.radiusMedium,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(12.w, 18.h, 18.w, 14.h),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SkeletonLoader(
                          width: 40.r,
                          height: 40.r,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        SizedBox(width: 6.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SkeletonLoader(
                              width: 205.w,
                              height: 16.h,
                              borderRadius: BorderRadius.circular(
                                StyleConstants.radiusSmall,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            SkeletonLoader(
                              width: 283.w,
                              height: 14.h,
                              borderRadius: BorderRadius.circular(
                                StyleConstants.radiusSmall,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),
                    Row(
                      children: [
                        SizedBox(width: 46.w),
                        SkeletonLoader(
                          width: 87.w,
                          height: 14.h,
                          borderRadius: BorderRadius.circular(
                            StyleConstants.radiusSmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Card(
              color: ColorSchemes.gray100,
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  StyleConstants.radiusMedium,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(12.w, 18.h, 18.w, 14.h),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SkeletonLoader(
                          width: 40.r,
                          height: 40.r,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        SizedBox(width: 6.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SkeletonLoader(
                              width: 205.w,
                              height: 16.h,
                              borderRadius: BorderRadius.circular(
                                StyleConstants.radiusSmall,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            SkeletonLoader(
                              width: 283.w,
                              height: 14.h,
                              borderRadius: BorderRadius.circular(
                                StyleConstants.radiusSmall,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),
                    Row(
                      children: [
                        SizedBox(width: 46.w),
                        SkeletonLoader(
                          width: 87.w,
                          height: 14.h,
                          borderRadius: BorderRadius.circular(
                            StyleConstants.radiusSmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Card(
              color: ColorSchemes.gray100,
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  StyleConstants.radiusMedium,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(12.w, 18.h, 18.w, 14.h),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SkeletonLoader(
                          width: 40.r,
                          height: 40.r,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        SizedBox(width: 6.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SkeletonLoader(
                              width: 205.w,
                              height: 16.h,
                              borderRadius: BorderRadius.circular(
                                StyleConstants.radiusSmall,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            SkeletonLoader(
                              width: 283.w,
                              height: 14.h,
                              borderRadius: BorderRadius.circular(
                                StyleConstants.radiusSmall,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),
                    Row(
                      children: [
                        SizedBox(width: 46.w),
                        SkeletonLoader(
                          width: 87.w,
                          height: 14.h,
                          borderRadius: BorderRadius.circular(
                            StyleConstants.radiusSmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}