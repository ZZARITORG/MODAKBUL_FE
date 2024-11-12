import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'skeleton_loader.dart';

class HomeScreenSkeleton extends StatelessWidget {
  const HomeScreenSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 카드
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 361.w,
                height: 103.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonLoader(width: 200.w, height: 16.h),
                          SizedBox(height: 8.h),
                          SkeletonLoader(width: 150.w, height: 12.h),
                        ],
                      ),
                      SkeletonLoader(
                        width: 50.w,
                        height: 50.h,
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // 중간 큰 카드
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 361.w,
                height: 150.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLoader(width: 300.w, height: 16.h),
                      SizedBox(height: 8.h),
                      SkeletonLoader(width: 280.w, height: 16.h),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          SkeletonLoader(
                            width: 16.w,
                            height: 16.h,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          SizedBox(width: 8.w),
                          SkeletonLoader(width: 120.w, height: 12.h),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          SkeletonLoader(
                            width: 16.w,
                            height: 16.h,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          SizedBox(width: 8.w),
                          SkeletonLoader(width: 100.w, height: 12.h),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // 하단 작은 카드들
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: SkeletonLoader(
                    width: 170.w,
                    height: 80.h,
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: SkeletonLoader(
                    width: 170.w,
                    height: 80.h,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}