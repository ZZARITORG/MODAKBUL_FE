import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';

class CustomToast {
  static void showToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    bool isVisible = true;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        bottom: 154.h,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: StatefulBuilder(
            builder: (context, setState) {
              return AnimatedOpacity(
                opacity: isVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300), // 페이드 아웃 시간
                onEnd: () {
                  if (!isVisible) overlayEntry.remove();
                },
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: ColorSchemes.orange000,
                      borderRadius: BorderRadius.circular(41.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(IconPath.warning ,width: 18.r,),
                        SizedBox(width: 6.w,),
                        Text(
                          message,
                          style: Theme.of(context).textTheme.body2.copyWith(color: ColorSchemes.orange200),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    // Overlay에 추가
    overlay.insert(overlayEntry);

    // 지정된 시간 후에 서서히 사라짐
    Future.delayed(const Duration(seconds: 1), () {
      isVisible = false; // opacity를 0으로 설정
      overlayEntry.markNeedsBuild(); // Overlay 업데이트
    });
  }
}
