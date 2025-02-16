import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/routes/routes.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/custom_button.dart';
import 'package:modakbul/widgets/custom_check_box.dart';
import 'package:modakbul/widgets/launch_custom_tab.dart';

class TermsAgreementScreen extends StatefulWidget {
  const TermsAgreementScreen({super.key});

  @override
  State<TermsAgreementScreen> createState() => _TermsAgreementScreenState();
}

class _TermsAgreementScreenState extends State<TermsAgreementScreen> {
  bool isActivateAll = false;
  bool isAgreeTerms = false;
  bool isAgreePrivacyPolicy = false;
  bool isAgreePushAlarm = false;

  void toggleAllCheckboxes() {
    setState(() {
      isActivateAll = !isActivateAll;
      isAgreeTerms = isActivateAll;
      isAgreePrivacyPolicy = isActivateAll;
      isAgreePushAlarm = isActivateAll;
    });
  }

  void _updateActivateAll() {
    setState(() {
      isActivateAll = isAgreeTerms && isAgreePrivacyPolicy && isAgreePushAlarm;
    });
  }

  _handleButtonPress() {
    Routes.navigateTo(context, Routes.authProfileScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackButtonAppBar(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding:
                EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 32.h,
                    ),
                    SizedBox(
                      width: 205.w,
                      child: Text(
                        '서비스 이용에 동의해주세요.',
                        style: Theme.of(context)
                            .textTheme
                            .bigHeadLine1
                            .copyWith(color: ColorSchemes.orange200),
                      ),
                    ),
                    SizedBox(
                      height: 52.h,
                    ),
                    SizedBox(
                      height: 62.h,
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: toggleAllCheckboxes,
                          style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                              backgroundColor: WidgetStateProperty.all(
                                isActivateAll
                                    ? ColorSchemes.orange200
                                    : ColorSchemes.orange100,
                              )),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 12.w,
                              ),
                              SizedBox(
                                height: 24.r,
                                width: 24.r,
                                child: SvgPicture.asset(isActivateAll
                                    ? IconPath.checkCircleActivateAll
                                    : IconPath.checkCircleDisabledAll),
                              ),
                              SizedBox(
                                width: 6.w,
                              ),
                              Text(
                                '약관 모두 동의',
                                style: Theme.of(context)
                                    .textTheme
                                    .smallHeadLine3
                                    .copyWith(color: ColorSchemes.white),
                              ),
                            ],
                          )),
                    ),
                    SizedBox(
                      height: 18.h,
                    ),

                    ///이용약관 체크박스
                    SizedBox(
                      height: 62.h,
                      child: ElevatedButton(
                          onPressed: () {},
                          style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                              backgroundColor: WidgetStateProperty.all(
                                ColorSchemes.white,
                              )),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Row(
                              children: [
                                CustomCheckbox(
                                    isChecked: isAgreeTerms,
                                    onChanged: (value) {
                                      setState(() {
                                        isAgreeTerms = value;
                                        _updateActivateAll();
                                      });
                                    }),
                                SizedBox(
                                  width: 6.w,
                                ),
                                Text(
                                  '(필수) 번개모임 어플 이용 약관',
                                  style: Theme.of(context)
                                      .textTheme
                                      .smallHeadLine3
                                      .copyWith(
                                      color: isAgreeTerms
                                          ? ColorSchemes.orange200
                                          : ColorSchemes.gray200),
                                ),
                                const Spacer(),
                                SvgPicture.asset(
                                  isAgreeTerms
                                      ? IconPath.arrowForwardOrange200
                                      : IconPath.arrowForwardGray200,
                                  height: 16.h,
                                  fit: BoxFit.scaleDown,
                                ),
                              ],
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    SizedBox(
                      height: 62.h,
                      child: ElevatedButton(
                          onPressed: () async {
                            await launchCustomTab(
                              context,
                              url: 'https://zzarit.notion.site/bf6e1538e9b54eafae9f11f94dd63a7e',
                              title: '모닥불 개인정보 처리방침',
                            );
                          },
                          style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                              backgroundColor: WidgetStateProperty.all(
                                ColorSchemes.white,
                              )),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Row(
                              children: [
                                CustomCheckbox(
                                    isChecked: isAgreePrivacyPolicy,
                                    onChanged: (value) {
                                      setState(() {
                                        isAgreePrivacyPolicy = value;
                                        _updateActivateAll();
                                      });
                                    }),
                                SizedBox(
                                  width: 6.w,
                                ),
                                SizedBox(
                                  width: 247.w,
                                  child: Text(
                                    '(필수) 번개모임 어플 개인정보 수집 및 이용에 대한 동의',
                                    style: Theme.of(context)
                                        .textTheme
                                        .smallHeadLine3
                                        .copyWith(
                                        color: isAgreePrivacyPolicy
                                            ? ColorSchemes.orange200
                                            : ColorSchemes.gray200),
                                  ),
                                ),
                                const Spacer(),
                                SvgPicture.asset(
                                  isAgreePrivacyPolicy
                                      ? IconPath.arrowForwardOrange200
                                      : IconPath.arrowForwardGray200,
                                  height: 16.h,
                                  fit: BoxFit.scaleDown,
                                ),
                              ],
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    SizedBox(
                      height: 62.h,
                      child: ElevatedButton(
                          onPressed: () {},
                          style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                              backgroundColor: WidgetStateProperty.all(
                                ColorSchemes.white,
                              )),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Row(
                              children: [
                                CustomCheckbox(
                                    isChecked: isAgreePushAlarm,
                                    onChanged: (value) {
                                      setState(() {
                                        isAgreePushAlarm = value;
                                        _updateActivateAll();
                                      });
                                    }),
                                SizedBox(
                                  width: 6.w,
                                ),
                                SizedBox(
                                  width: 247.w,
                                  child: Text(
                                    '(선택) 번개모임 어플 PUSH알림 동의',
                                    style: Theme.of(context)
                                        .textTheme
                                        .smallHeadLine3
                                        .copyWith(
                                        color: isAgreePushAlarm
                                            ? ColorSchemes.orange200
                                            : ColorSchemes.gray200),
                                  ),
                                ),
                                const Spacer(),
                                SvgPicture.asset(
                                  isAgreePushAlarm
                                      ? IconPath.arrowForwardOrange200
                                      : IconPath.arrowForwardGray200,
                                  height: 16.h,
                                  fit: BoxFit.scaleDown,
                                ),
                              ],
                            ),
                          )),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 56.h,
                      width: double.infinity,
                      child: CustomButton(
                          text: '다음',
                          onPressed: (isAgreeTerms && isAgreePrivacyPolicy)
                              ? _handleButtonPress
                              : null,
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
            )
          ],
        ),
      ),
    );
  }
}
