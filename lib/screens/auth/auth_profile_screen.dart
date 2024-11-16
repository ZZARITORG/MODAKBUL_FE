import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/custom_button.dart';

class AuthProfileScreen extends StatelessWidget {
  const AuthProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackButtonAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: StyleConstants.defaultPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 42.h,
            ),
            Text('프로필 사진을 선택해주세요',
                style: Theme.of(context)
                    .textTheme
                    .bigHeadLine3
                    .copyWith(color: ColorSchemes.gray500)),
            SizedBox(
              height: 6.h,
            ),
            Text('사용자님의 멋진 모습을 보여주세요.',
                style: Theme.of(context)
                    .textTheme
                    .body2
                    .copyWith(color: ColorSchemes.gray200)),
            SizedBox(
              height: 73.h,
            ),
            Center(
              child: CircleAvatar(
                radius: StyleConstants.circleSizeXXXL,
                backgroundColor: ColorSchemes.orange100,
                child: CircleAvatar(
                  radius: 120.r,
                  backgroundColor: ColorSchemes.white,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                            height: 54.r,
                            width: 54.r,
                            child: SvgPicture.asset(
                              IconPath.photoCameraOrange200,
                              width: 37.r,
                              fit: BoxFit.scaleDown,
                            )),
                        Text(
                          '사진올리기',
                          style: Theme.of(context)
                              .textTheme
                              .body2
                              .copyWith(color: ColorSchemes.orange200),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: TextButton(
                  onPressed: () {},
                  child: Text(
                    '기본이미지 선택하기',
                    style: Theme.of(context)
                        .textTheme
                        .smallHeadLine3
                        .copyWith(color: ColorSchemes.orange100),
                  )),
            ),
            SizedBox(
              height: 14.h,
            ),
            SizedBox(
              height: 56.h,
              width: double.infinity,
              child: CustomButton(
                text: '회원가입 완료',
                onPressed: () {},
                buttonColor: ColorSchemes.orange200,
                textStyle: Theme.of(context).textTheme.smallHeadLine2,
                textColor: ColorSchemes.white,
              ),
            ),
            SizedBox(
              height: 16.h,
            )
          ],
        ),
      ),
    );
  }
}
