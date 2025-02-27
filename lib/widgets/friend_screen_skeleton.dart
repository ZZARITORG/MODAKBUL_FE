import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'skeleton_loader.dart';

class FriendScreenSkeleton extends StatelessWidget {
  const FriendScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('가나다순',
                style: Theme.of(context)
                    .textTheme
                    .bigHeadLine4
                    .copyWith(color: ColorSchemes.gray200)),
            Text('필터',
                style: Theme.of(context)
                    .textTheme
                    .body3
                    .copyWith(color: ColorSchemes.gray200))
          ],
        ),
        SizedBox(height: 14.h),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: 6,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  SizedBox(height: 10.h),
                  Row(
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
                                  width: 99.w,
                                  height: 16.h,
                                  borderRadius: BorderRadius.circular(
                                      StyleConstants.radiusMedium)),
                              SizedBox(height: 10.h),
                              SkeletonLoader(
                                  width: 111.w,
                                  height: 14.h,
                                  borderRadius: BorderRadius.circular(
                                      StyleConstants.radiusMedium)),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
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
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h)
                ],
              );
            })
      ],
    );
  }
}
