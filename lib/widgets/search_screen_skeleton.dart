import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'skeleton_loader.dart';

class SearchScreenSkeleton extends StatelessWidget {
  const SearchScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSchemes.gray000,
      body: Column(
        children: [
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 32.h),
                Container(
                  width: double.infinity,
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(StyleConstants.radiusMedium),
                    color: ColorSchemes.gray100,
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('친구요청',
                        style: Theme.of(context)
                            .textTheme
                            .bigHeadLine4
                            .copyWith(color: ColorSchemes.gray200)),
                    Text('전체보기',
                        style: Theme.of(context)
                            .textTheme
                            .body3
                            .copyWith(color: ColorSchemes.gray200))
                  ],
                ),
                SizedBox(height: 24.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLoader(
                        width: 96.r,
                        height: 96.r,
                        borderRadius: BorderRadius.circular(96.r)),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SkeletonLoader(
                                  width: 42.w,
                                  height: 24.h,
                                  borderRadius: BorderRadius.circular(
                                      StyleConstants.radiusMedium)),
                              Row(
                                children: [
                                  SkeletonLoader(
                                      width: 42.w,
                                      height: 24.h,
                                      borderRadius: BorderRadius.circular(
                                          StyleConstants.radiusMedium)),
                                  SizedBox(width: 4.w)
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          SkeletonLoader(
                              width: 111.w,
                              height: 16.h,
                              borderRadius: BorderRadius.circular(
                                  StyleConstants.radiusMedium)),
                          SizedBox(height: 6.h),
                          Row(
                            children: [
                              Expanded(
                                  child: SkeletonLoader(
                                      width: double.infinity,
                                      height: 40.h,
                                      borderRadius: BorderRadius.circular(
                                          StyleConstants.radiusMedium))),
                              SizedBox(width: 7.w),
                              Expanded(
                                  child: SkeletonLoader(
                                      width: double.infinity,
                                      height: 40.h,
                                      borderRadius: BorderRadius.circular(
                                          StyleConstants.radiusMedium))),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLoader(
                        width: 96.r,
                        height: 96.r,
                        borderRadius: BorderRadius.circular(96.r)),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SkeletonLoader(
                                  width: 42.w,
                                  height: 24.h,
                                  borderRadius: BorderRadius.circular(
                                      StyleConstants.radiusMedium)),
                              Row(
                                children: [
                                  SkeletonLoader(
                                      width: 42.w,
                                      height: 24.h,
                                      borderRadius: BorderRadius.circular(
                                          StyleConstants.radiusMedium)),
                                  SizedBox(width: 4.w)
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          SkeletonLoader(
                              width: 111.w,
                              height: 16.h,
                              borderRadius: BorderRadius.circular(
                                  StyleConstants.radiusMedium)),
                          SizedBox(height: 6.h),
                          Row(
                            children: [
                              Expanded(
                                  child: SkeletonLoader(
                                      width: double.infinity,
                                      height: 40.h,
                                      borderRadius: BorderRadius.circular(
                                          StyleConstants.radiusMedium))),
                              SizedBox(width: 7.w),
                              Expanded(
                                  child: SkeletonLoader(
                                      width: double.infinity,
                                      height: 40.h,
                                      borderRadius: BorderRadius.circular(
                                          StyleConstants.radiusMedium))),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h)
              ],
            ),
          ),
          Divider(
            thickness: 2.h,
            height: 2.h,
            color: ColorSchemes.gray100
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 32.h),
                Text('알 수도 있는 사람',
                    style: Theme.of(context)
                        .textTheme
                        .bigHeadLine4
                        .copyWith(color: ColorSchemes.gray200)
                ),
                SizedBox(height: 24.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLoader(
                        width: 96.r,
                        height: 96.r,
                        borderRadius: BorderRadius.circular(96.r)),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SkeletonLoader(
                                  width: 42.w,
                                  height: 24.h,
                                  borderRadius: BorderRadius.circular(
                                      StyleConstants.radiusMedium)),
                              Row(
                                children: [
                                  SkeletonLoader(
                                      width: 42.w,
                                      height: 24.h,
                                      borderRadius: BorderRadius.circular(
                                          StyleConstants.radiusMedium)),
                                  SizedBox(width: 4.w)
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          SkeletonLoader(
                              width: 111.w,
                              height: 16.h,
                              borderRadius: BorderRadius.circular(
                                  StyleConstants.radiusMedium)),
                          SizedBox(height: 6.h),
                          Row(
                            children: [
                              Expanded(
                                  child: SkeletonLoader(
                                      width: double.infinity,
                                      height: 40.h,
                                      borderRadius: BorderRadius.circular(
                                          StyleConstants.radiusMedium))),
                              SizedBox(width: 7.w),
                              Expanded(
                                  child: SkeletonLoader(
                                      width: double.infinity,
                                      height: 40.h,
                                      borderRadius: BorderRadius.circular(
                                          StyleConstants.radiusMedium))),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLoader(
                        width: 96.r,
                        height: 96.r,
                        borderRadius: BorderRadius.circular(96.r)),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SkeletonLoader(
                                  width: 42.w,
                                  height: 24.h,
                                  borderRadius: BorderRadius.circular(
                                      StyleConstants.radiusMedium)),
                              Row(
                                children: [
                                  SkeletonLoader(
                                      width: 42.w,
                                      height: 24.h,
                                      borderRadius: BorderRadius.circular(
                                          StyleConstants.radiusMedium)),
                                  SizedBox(width: 4.w)
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          SkeletonLoader(
                              width: 111.w,
                              height: 16.h,
                              borderRadius: BorderRadius.circular(
                                  StyleConstants.radiusMedium)),
                          SizedBox(height: 6.h),
                          Row(
                            children: [
                              Expanded(
                                  child: SkeletonLoader(
                                      width: double.infinity,
                                      height: 40.h,
                                      borderRadius: BorderRadius.circular(
                                          StyleConstants.radiusMedium))),
                              SizedBox(width: 7.w),
                              Expanded(
                                  child: SkeletonLoader(
                                      width: double.infinity,
                                      height: 40.h,
                                      borderRadius: BorderRadius.circular(
                                          StyleConstants.radiusMedium))),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
