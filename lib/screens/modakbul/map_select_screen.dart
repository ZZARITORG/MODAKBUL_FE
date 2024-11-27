import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/constants/app_constants.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/main.dart';
import 'package:modakbul/routes/routes.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/custom_button.dart';

class MapSelectScreen extends StatelessWidget {
  const MapSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackButtonAppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: ColorSchemes.orange000,
              height: double.infinity,
              width: double.infinity,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: ColorSchemes.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(StyleConstants.radiusLarge),
                    topRight: Radius.circular(StyleConstants.radiusLarge),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: StyleConstants.defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 32.h,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 24.r,
                            width: 24.r,
                            child: Center(
                              child: SvgPicture.asset(
                                IconPath.pinDropOrange200,
                                width: 16.r,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    ///텍스트 영역 잡아야댐
                                    Flexible(
                                      child: Text(
                                        '서현역 콩쥐팥쥐',
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .smallHeadLine2
                                            .copyWith(color: ColorSchemes.gray500),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 6.w,
                                    ),
                                    Text(
                                      '2km',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(color: ColorSchemes.gray200),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 6.h,
                                ),

                                ///여기 영역 잡아야댐
                                SizedBox(
                                  width: double.infinity,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '경기도 성남시 분당구 황새울로 360번길 12 대명프라자',
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(color: ColorSchemes.gray400),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16.w,),
                        ],
                      ),
                      SizedBox(
                        height: 34.h,
                      ),
                      Stack(
                        children: [
                          TextField(
                            maxLength: AppConstants.maxAddressLength,
                            cursorColor: ColorSchemes.orange100,
                            onTapOutside: (event) =>
                                FocusManager.instance.primaryFocus?.unfocus(),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            style: Theme.of(context).textTheme.body1.copyWith(
                                color: ColorSchemes.gray500
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              hintText: '상세주소가 필요하다면 입력해주세요.',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .body1
                                  .copyWith(color: ColorSchemes.gray200),
                              isDense: true,
                              contentPadding:
                              EdgeInsets.only(left: 4.w, bottom: 4.h),
                              border: InputBorder.none,
                              errorText: null,
                              errorStyle: const TextStyle(
                                  color: ColorSchemes.orange100, fontSize: 0),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              height: 2.w,
                              decoration: BoxDecoration(
                                  color: ColorSchemes.gray100,
                                  borderRadius: BorderRadius.circular(2.r)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h,),
                      SizedBox(
                        height: 56.h,
                        width: double.infinity,
                        child: CustomButton(
                            text: '다음',
                            onPressed: () {
                              ///이부분 기능 개발할때 생각
                              Navigator.of(context).popUntil((route) => route.isFirst);
                            },
                            buttonColor: ColorSchemes.orange200,
                            textStyle: Theme.of(context).textTheme.smallHeadLine2,
                            textColor: ColorSchemes.white),
                      ),
                      SizedBox(
                        height: 16.h,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
