import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/custom_button.dart';
import 'package:modakbul/widgets/modakbul_map_screen_skeleton.dart';

import '../../themes/color_schemes.dart';

class ModakbulMapDetailScreen extends StatefulWidget {
  const ModakbulMapDetailScreen({Key? key}) : super(key: key);

  @override
  State<ModakbulMapDetailScreen> createState() =>
      _ModakbulMapDetailScreenState();
}

class _ModakbulMapDetailScreenState extends State<ModakbulMapDetailScreen> {
  final String location = '서울 중구 마른내로 79 세운푸르지오 헤리시티 제 105호';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSchemes.gray000,
      appBar: BackButtonAppBar(
        backgroundColor: ColorSchemes.gray000
      ),
      body: /*Skeleton 들어갈 자리 */ Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),
                    Text(
                      '모닥불이 피워진 위치를\n확인해 주세요',
                      style: Theme.of(context)
                          .textTheme
                          .bigHeadLine2
                          .copyWith(color: ColorSchemes.gray500, height: 1.5),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        location,
                        style: Theme.of(context).textTheme.body2.copyWith(
                            color: ColorSchemes.orange200, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 32.h,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: Center(
                    child: Text('지도 영역'),
                  ),
                ),
              )
            ],
          ),
          Positioned(
            left: 16.w,
            right: 16.w,
            bottom: 69.h,
            child: SizedBox(
              height: 56.h,
              child: CustomButton(
                  text: '주소 복사하기',
                  onPressed: () {},
                  buttonColor: ColorSchemes.orange200,
                  textStyle: Theme.of(context).textTheme.smallHeadLine2,
                  textColor: ColorSchemes.white),
            ),
          )
        ],
      ),
    );
  }
}
