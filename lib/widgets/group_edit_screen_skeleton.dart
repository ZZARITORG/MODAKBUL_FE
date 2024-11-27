import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'skeleton_loader.dart';

class GroupEditScreenSkeleton extends StatelessWidget {
  const GroupEditScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSchemes.gray000,
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 38.h),
            SkeletonLoader(
                width: 202.w,
                height: 24.h,
                borderRadius:
                    BorderRadius.circular(StyleConstants.radiusMedium)),
            SizedBox(height: 14.h),
            Divider(height: 2.h, thickness: 2.h, color: ColorSchemes.gray100),
            SizedBox(height: 24.h),
            Container(
              width: 361.w,
              height: 50.h,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(StyleConstants.radiusMedium),
                color: ColorSchemes.gray100,
              ),
            ),
            SizedBox(height: 23.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonLoader(
                    width: 133.w,
                    height: 24.h,
                    borderRadius:
                        BorderRadius.circular(StyleConstants.radiusMedium)),
                SkeletonLoader(
                    width: 28.w,
                    height: 14.h,
                    borderRadius:
                        BorderRadius.circular(StyleConstants.radiusMedium)),
              ],
            ),
            SizedBox(height: 19.h),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: 6,
                itemBuilder: (context, index) {
                  return SizedBox(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.w, 10.h, 0.w, 10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SkeletonLoader(
                                  width: 64.r,
                                  height: 64.r,
                                  borderRadius: BorderRadius.circular(64)),
                              SizedBox(width: 8.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SkeletonLoader(
                                      width: 42.w,
                                      height: 24.h,
                                      borderRadius: BorderRadius.circular(
                                          StyleConstants.radiusMedium)),
                                  SizedBox(height: 8.h),
                                  SkeletonLoader(
                                      width: 111.w,
                                      height: 16.h,
                                      borderRadius: BorderRadius.circular(
                                          StyleConstants.radiusMedium)),
                                ],
                              )
                            ],
                          ),
                          SkeletonLoader(
                              width: 28.r,
                              height: 28.r,
                              borderRadius: BorderRadius.circular(28))
                        ],
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
