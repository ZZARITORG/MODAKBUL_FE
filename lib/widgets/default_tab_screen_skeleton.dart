import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'skeleton_loader.dart';

class DefaultTabScreenSkeleton extends StatelessWidget {
  const DefaultTabScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 14.h),
            SizedBox(
              width: double.infinity,
              height: 103.h,
              child: Card(
                color: ColorSchemes.white,
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(StyleConstants.radiusMedium)),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 14.h),
                          SkeletonLoader(
                              width: 181.w,
                              height: 24.h,
                              borderRadius: BorderRadius.circular(
                                  StyleConstants.radiusMedium)),
                          SizedBox(height: 12.h),
                          SkeletonLoader(
                              width: 130.w,
                              height: 14.h,
                              borderRadius: BorderRadius.circular(
                                  StyleConstants.radiusMedium))
                        ],
                      ),
                      SkeletonLoader(
                          width: 75.r,
                          height: 75.r,
                          borderRadius: BorderRadius.circular(
                              StyleConstants.radiusLarge))
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 14.h),
            SizedBox(
              width: double.infinity,
              height: 238.h,
              child: Card(
                color: ColorSchemes.white,
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(StyleConstants.radiusMedium)),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15.w, 34.h, 16.w, 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLoader(
                          width: 130.w,
                          height: 14.h,
                          borderRadius: BorderRadius.circular(
                              StyleConstants.radiusMedium)),
                      SizedBox(height: 9),
                      SkeletonLoader(
                          width: 293.w,
                          height: 24.h,
                          borderRadius: BorderRadius.circular(
                              StyleConstants.radiusMedium)),
                      SizedBox(height: 23.h),
                      Row(
                        children: [
                          SizedBox(width: 4.w),
                          SkeletonLoader(
                              width: 14.r,
                              height: 14.r,
                              borderRadius: BorderRadius.circular(
                                  StyleConstants.radiusSmall)),
                          SizedBox(width: 10.w),
                          SkeletonLoader(
                              width: 99.w,
                              height: 14.h,
                              borderRadius: BorderRadius.circular(
                                  StyleConstants.radiusMedium))
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          SizedBox(width: 4.w),
                          SkeletonLoader(
                              width: 14.r,
                              height: 14.r,
                              borderRadius: BorderRadius.circular(
                                  StyleConstants.radiusSmall)),
                          SizedBox(width: 10.w),
                          SkeletonLoader(
                              width: 99.w,
                              height: 14.h,
                              borderRadius: BorderRadius.circular(
                                  StyleConstants.radiusMedium))
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          SizedBox(width: 232.w),
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
                                      borderRadius:
                                          BorderRadius.circular(32)),
                                ),
                                Positioned(
                                    left: 24.w,
                                    child: CircleAvatar(
                                      radius: StyleConstants.circleSizeXXXXXS,
                                      backgroundColor: Colors.white,
                                      child: SkeletonLoader(
                                          width: 32.r,
                                          height: 32.r,
                                          borderRadius:
                                              BorderRadius.circular(32)),
                                    ))
                              ],
                            ),
                          ),
                          SizedBox(width: 4.w),
                          SkeletonLoader(
                              width: 23.w,
                              height: 14.h,
                              borderRadius: BorderRadius.circular(
                                  StyleConstants.radiusMedium))
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          SizedBox(width: 137.w),
                          SkeletonLoader(
                              width: 18.w,
                              height: 6.h,
                              borderRadius: BorderRadius.circular(4)),
                          SizedBox(width: 4.w),
                          SkeletonLoader(
                              width: 6.r,
                              height: 6.r,
                              borderRadius: BorderRadius.circular(6)),
                          SizedBox(width: 4.w),
                          SkeletonLoader(
                              width: 6.r,
                              height: 6.r,
                              borderRadius: BorderRadius.circular(6)),
                          SizedBox(width: 4.w),
                          SkeletonLoader(
                              width: 6.r,
                              height: 6.r,
                              borderRadius: BorderRadius.circular(6)),
                          SizedBox(width: 4.w),
                          SkeletonLoader(
                              width: 6.r,
                              height: 6.r,
                              borderRadius: BorderRadius.circular(6)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '약속된 모닥불',
                  style: Theme.of(context)
                      .textTheme
                      .bigHeadLine4
                      .copyWith(color: ColorSchemes.gray200),
                ),
                Text(
                  '전체보기',
                  style: Theme.of(context)
                      .textTheme
                      .body3
                      .copyWith(color: ColorSchemes.gray200),
                )
              ],
            ),
            SizedBox(height: 14.h)
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Column(
            children: [
              SizedBox(
                height: 154.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: SizedBox(
                        width: 285.w,
                        child: Card(
                          color: ColorSchemes.white,
                          elevation: 0,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                StyleConstants.radiusMedium),
                          ),
                          child: Padding(
                            padding:
                                EdgeInsets.fromLTRB(14.w, 24.h, 69.w, 24.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SkeletonLoader(
                                  width: 202.w,
                                  height: 24.h,
                                  borderRadius: BorderRadius.circular(
                                      StyleConstants.radiusMedium),
                                ),
                                SizedBox(height: 4.h),
                                SkeletonLoader(
                                  width: 202.w,
                                  height: 24.h,
                                  borderRadius: BorderRadius.circular(
                                      StyleConstants.radiusMedium),
                                ),
                                SizedBox(height: 14.h),
                                Row(
                                  children: [
                                    SkeletonLoader(
                                      width: 14.r,
                                      height: 14.r,
                                      borderRadius: BorderRadius.circular(
                                          StyleConstants.radiusSmall),
                                    ),
                                    SizedBox(width: 10.w),
                                    SkeletonLoader(
                                      width: 99.w,
                                      height: 14.h,
                                      borderRadius: BorderRadius.circular(
                                          StyleConstants.radiusMedium),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.h),
                                Row(
                                  children: [
                                    SkeletonLoader(
                                      width: 14.r,
                                      height: 14.r,
                                      borderRadius: BorderRadius.circular(
                                          StyleConstants.radiusSmall),
                                    ),
                                    SizedBox(width: 10.w),
                                    SkeletonLoader(
                                      width: 99.w,
                                      height: 14.h,
                                      borderRadius: BorderRadius.circular(
                                          StyleConstants.radiusMedium),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
