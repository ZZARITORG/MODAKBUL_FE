import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'skeleton_loader.dart';

class GroupScreenSkeleton extends StatelessWidget {
  const GroupScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
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
          Padding(
            padding: EdgeInsets.only(left: 4.w, right: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('최신순',
                    style: Theme.of(context)
                        .textTheme
                        .bigHeadLine4
                        .copyWith(color: ColorSchemes.gray200)),
                Text('정렬',
                    style: Theme.of(context)
                        .textTheme
                        .body3
                        .copyWith(color: ColorSchemes.gray200))
              ],
            ),
          ),
          Card(
            color: ColorSchemes.gray100,
            elevation: 0,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    StyleConstants.radiusMedium)),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 22.h, bottom: 18.h),
                child: Column(
                  children: [
                    SizedBox(
                      width: 98.w,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: StyleConstants.circleSizeXXS,
                            backgroundColor: Colors.white,
                            child: SkeletonLoader(
                                width: 38.r,
                                height: 38.r,
                                borderRadius:
                                BorderRadius.circular(38)),
                          ),
                          Positioned(
                              left: 28.w,
                              child: CircleAvatar(
                                radius:
                                StyleConstants.circleSizeXXS,
                                backgroundColor: Colors.white,
                                child: SkeletonLoader(
                                    width: 38.r,
                                    height: 38.r,
                                    borderRadius:
                                    BorderRadius.circular(38)),
                              )),
                          Positioned(
                              left: 56.w,
                              child: CircleAvatar(
                                radius:
                                StyleConstants.circleSizeXXS,
                                backgroundColor: Colors.white,
                                child: SkeletonLoader(
                                    width: 38.r,
                                    height: 38.r,
                                    borderRadius:
                                    BorderRadius.circular(38)),
                              ))
                        ],
                      ),
                    ),
                    SizedBox(height: 9.h),
                    SkeletonLoader(width: 90.w, height: 14.h, borderRadius: BorderRadius.circular(
                        StyleConstants.radiusMedium))
                  ],
                ),
              ),
            )
          ),
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(top: 14.h),
                  child: Card(
                      color: ColorSchemes.white,
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              StyleConstants.radiusMedium)),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(18.w, 18.h, 16.w, 45.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              SizedBox(width: 305.w),
                              SkeletonLoader(
                                  width: 4.r,
                                  height: 4.r,
                                  borderRadius: BorderRadius.circular(4)),
                              SizedBox(width: 4.w),
                              SkeletonLoader(
                                  width: 4.r,
                                  height: 4.r,
                                  borderRadius: BorderRadius.circular(4)),
                              SizedBox(width: 4.w),
                              SkeletonLoader(
                                  width: 4.r,
                                  height: 4.r,
                                  borderRadius: BorderRadius.circular(4))
                            ]),
                            SizedBox(height: 20.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SkeletonLoader(
                                        width: 202.w,
                                        height: 24.h,
                                        borderRadius: BorderRadius.circular(
                                            StyleConstants.radiusMedium)),
                                    SizedBox(height: 8.h),
                                    SkeletonLoader(
                                        width: 167.w,
                                        height: 14.h,
                                        borderRadius: BorderRadius.circular(
                                            StyleConstants.radiusMedium)),
                                  ],
                                ),
                                SizedBox(width: 27.w),
                                SizedBox(
                                  width: 98.w,
                                  child: Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: StyleConstants.circleSizeXXS,
                                        backgroundColor: Colors.white,
                                        child: SkeletonLoader(
                                            width: 38.r,
                                            height: 38.r,
                                            borderRadius:
                                            BorderRadius.circular(38)),
                                      ),
                                      Positioned(
                                          left: 28.w,
                                          child: CircleAvatar(
                                            radius:
                                            StyleConstants.circleSizeXXS,
                                            backgroundColor: Colors.white,
                                            child: SkeletonLoader(
                                                width: 38.r,
                                                height: 38.r,
                                                borderRadius:
                                                BorderRadius.circular(38)),
                                          )),
                                      Positioned(
                                          left: 56.w,
                                          child: CircleAvatar(
                                            radius:
                                            StyleConstants.circleSizeXXS,
                                            backgroundColor: Colors.white,
                                            child: SkeletonLoader(
                                                width: 38.r,
                                                height: 38.r,
                                                borderRadius:
                                                BorderRadius.circular(38)),
                                          ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      )),
                );
              }),
        ],
      ),
    );
  }
}
