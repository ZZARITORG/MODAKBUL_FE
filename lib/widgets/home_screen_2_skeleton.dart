import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'skeleton_loader.dart';

class HomeScreen2Skeleton extends StatelessWidget {
  const HomeScreen2Skeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSchemes.gray000,
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 14.h),
            SizedBox(
              width: 361.w,
              height: 103.h,
              child: Card(
                color: ColorSchemes.gray100,
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(StyleConstants.radiusMedium)),
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                SkeletonLoader(
                    width: 71.w,
                    height: 36.h,
                    borderRadius:
                    BorderRadius.circular(StyleConstants.radiusMedium)),
                SizedBox(width: 8.w),
                SkeletonLoader(
                    width: 65.w,
                    height: 36.h,
                    borderRadius:
                    BorderRadius.circular(StyleConstants.radiusMedium)),
                SizedBox(width: 8.w),
                SkeletonLoader(
                    width: 53.w,
                    height: 36.h,
                    borderRadius:
                    BorderRadius.circular(StyleConstants.radiusMedium)),
                SizedBox(width: 8.w),
                SkeletonLoader(
                    width: 81.w,
                    height: 36.h,
                    borderRadius:
                    BorderRadius.circular(StyleConstants.radiusMedium))
              ],
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Card(
                      color: ColorSchemes.white,
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              StyleConstants.radiusMedium)),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(16.w, 24.h, 27.w, 23.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SkeletonLoader(
                                            width: 42.r,
                                            height: 42.r,
                                            borderRadius:
                                            BorderRadius.circular(42)),
                                        SizedBox(width: 4.w),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            SkeletonLoader(
                                                width: 42.w,
                                                height: 18.h,
                                                borderRadius: BorderRadius
                                                    .circular(
                                                    StyleConstants
                                                        .radiusSmall)),
                                            SizedBox(height: 3.h),
                                            SkeletonLoader(
                                                width: 58.w,
                                                height: 14.h,
                                                borderRadius: BorderRadius
                                                    .circular(
                                                    StyleConstants
                                                        .radiusSmall))
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
                                                radius: StyleConstants
                                                    .circleSizeXXXXXS,
                                                backgroundColor: Colors.white,
                                                child: SkeletonLoader(
                                                    width: 32.r,
                                                    height: 32.r,
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        32)),
                                              ),
                                              Positioned(
                                                  left: 24.w,
                                                  child: CircleAvatar(
                                                    radius: StyleConstants
                                                        .circleSizeXXXXXS,
                                                    backgroundColor:
                                                    Colors.white,
                                                    child: SkeletonLoader(
                                                        width: 32.r,
                                                        height: 32.r,
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(32)),
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
                                SizedBox(height: 21.h),
                                SkeletonLoader(
                                    width: 286.w,
                                    height: 24.h,
                                    borderRadius: BorderRadius.circular(
                                        StyleConstants.radiusMedium)),
                                SizedBox(height: 13.h),
                                SkeletonLoader(
                                    width: 286.w,
                                    height: 14.h,
                                    borderRadius: BorderRadius.circular(
                                        StyleConstants.radiusMedium)),
                                SizedBox(height: 8.h),
                                SkeletonLoader(
                                    width: 286.w,
                                    height: 14.h,
                                    borderRadius: BorderRadius.circular(
                                        StyleConstants.radiusMedium))
                              ],
                            ),
                          ),
                          Divider(
                            height: 1.h,
                            thickness: 1.h,
                            color: ColorSchemes.gray100,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(16.w, 18.h, 0.w, 24.h),
                            child: Column(
                              children: [
                                Row(children: [
                                  SkeletonLoader(
                                      width: 14.r,
                                      height: 14.r,
                                      borderRadius: BorderRadius.circular(14)),
                                  SizedBox(width: 10),
                                  SkeletonLoader(
                                      width: 99.w,
                                      height: 14.h,
                                      borderRadius: BorderRadius.circular(
                                          StyleConstants.radiusMedium))
                                ]),
                                SizedBox(height: 22),
                                Row(children: [
                                  SkeletonLoader(
                                      width: 14.r,
                                      height: 14.r,
                                      borderRadius: BorderRadius.circular(14)),
                                  SizedBox(width: 10),
                                  SkeletonLoader(
                                      width: 99.w,
                                      height: 14.h,
                                      borderRadius: BorderRadius.circular(
                                          StyleConstants.radiusMedium))
                                ])
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}