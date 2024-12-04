import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/main.dart';
import 'package:modakbul/routes/routes.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/create_meeting_button.dart';
import 'package:modakbul/widgets/custom_button.dart';
import 'package:modakbul/widgets/custom_calender_picker.dart';
import 'package:modakbul/widgets/custom_time_picker.dart';
import 'package:modakbul/widgets/logo_app_bar.dart';


class CreateModakbulScreen extends StatefulWidget {
  const CreateModakbulScreen({super.key});

  @override
  State<CreateModakbulScreen> createState() => _CreateModakbulScreenState();
}

class _CreateModakbulScreenState extends State<CreateModakbulScreen> {
  DateTime? selectDate;

  void _onDateSelected(DateTime date) {
    setState(() {
      selectDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorSchemes.gray000,
      appBar: const LogoAppBar(
        backgroundColor: ColorSchemes.gray000,
      ),
      body: Padding(
        padding:
        EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 24.h,
            ),
            SizedBox(
                width: 322.w,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    '원활한 모닥불을 위해\n아래 내용을 선택해주세요.',
                    maxLines: 2,
                    style: Theme.of(context)
                        .textTheme
                        .bigHeadLine2
                        .copyWith(color: ColorSchemes.gray500),
                  ),
                )),
            SizedBox(
              height: 8.h,
            ),
            Text(
              '그룹을 선택하면 자동으로 알림이 전송됩니다.',
              style: Theme.of(context)
                  .textTheme
                  .body2
                  .copyWith(color: ColorSchemes.gray300),
            ),
            SizedBox(
              height: 71.h,
            ),
            CreateMeetingButton(
              type: '그룹',
              content: '그룹 선택',
              onPressed: () =>
                  Routes.navigateTo(context, Routes.groupSelectScreen),
              icon: IconPath.groupOrange100,
              typeColor: ColorSchemes.orange100,
              contentColor: ColorSchemes.gray200,
              arrowIcon: IconPath.arrowForward15Gray200,
              iconWidth: 20.r,
            ),
            SizedBox(
              height: 14.h,
            ),
            CreateMeetingButton(
              type: '위치',
              content: '위치 선택',
              onPressed: () =>
                  Routes.navigateTo(context, Routes.mapSearchScreen),
              icon: IconPath.pinDropOrange100,
              typeColor: ColorSchemes.orange100,
              contentColor: ColorSchemes.gray200,
              arrowIcon: IconPath.arrowForward15Gray200,
              iconWidth: 16.r,
            ),
            SizedBox(
              height: 14.h,
            ),
            CreateMeetingButton(
              type: '날짜',
              content: selectDate != null
                  ? DateFormat('M월 d일').format(selectDate!)
                  : '날짜 선택',
              onPressed: () => showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(StyleConstants.radiusLarge)),
                  ),
                  builder: (context) {
                    return SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: StyleConstants.defaultPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 10.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 28.r,
                                  width: 28.r,
                                  child: IconButton(
                                      padding: EdgeInsets.zero, // 패딩 제거
                                      constraints: const BoxConstraints(),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: SvgPicture.asset(
                                        IconPath.close,
                                        width: 14.r,
                                      )),
                                ),
                              ],
                            ),
                            Text(
                              '날짜를 선택해주세요',
                              style: Theme.of(context)
                                  .textTheme
                                  .bigHeadLine3
                                  .copyWith(color: ColorSchemes.gray500),
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            Text(
                              '기간은 최대 1달까지 선택할 수 있습니다!',
                              style: Theme.of(context)
                                  .textTheme
                                  .body2
                                  .copyWith(color: ColorSchemes.gray500),
                            ),
                            SizedBox(
                              height: 24.h,
                            ),
                            CustomCalendarPicker(onDateSelected: _onDateSelected,),
                          ],
                        ),
                      ),
                    );
                  }),
              icon: selectDate != null ? IconPath.calendarMonthOrange200 : IconPath.calendarMonthOrange100,
              typeColor: selectDate != null ? ColorSchemes.orange200 : ColorSchemes.orange100,
              contentColor: selectDate != null ? ColorSchemes.orange100 : ColorSchemes.gray200,
              arrowIcon: selectDate != null ? IconPath.arrowForward15Orange100 : IconPath.arrowForward15Gray200,
              iconWidth: 19.r,
            ),
            SizedBox(
              height: 14.h,
            ),
            CreateMeetingButton(
              type: '시간',
              content: '시간 선택',
              onPressed: () => showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(StyleConstants.radiusLarge)),
                ),
                builder: (context) {
                  return SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: StyleConstants.defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 28.r,
                                width: 28.r,
                                child: IconButton(
                                    padding: EdgeInsets.zero, // 패딩 제거
                                    constraints: const BoxConstraints(),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: SvgPicture.asset(
                                      IconPath.close,
                                      width: 14.r,
                                    )),
                              ),
                            ],
                          ),
                          Text(
                            '시간을 선택해주세요',
                            style: Theme.of(context)
                                .textTheme
                                .bigHeadLine3
                                .copyWith(color: ColorSchemes.gray500),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Text(
                            '다른 모닥들과 모일 시간을 선택해주세요!',
                            style: Theme.of(context)
                                .textTheme
                                .body2
                                .copyWith(color: ColorSchemes.gray500),
                          ),
                          SizedBox(
                            height: 24.h,
                          ),
                          CustomTimePicker(),
                        ],
                      ),
                    ),
                  );
                }),
              icon: IconPath.timeOrange100,
              typeColor: ColorSchemes.orange100,
              contentColor: ColorSchemes.gray200,
              arrowIcon: IconPath.arrowForward15Gray200,
              iconWidth: 20.r,
            ),
            const Spacer(),
            SizedBox(
              height: 56.h,
              width: double.infinity,
              child: CustomButton(
                  text: '선택완료',
                  onPressed: () =>
                      Routes.navigateTo(context, Routes.createContentScreen),
                  buttonColor: ColorSchemes.orange200,
                  textStyle: Theme.of(context).textTheme.smallHeadLine2,
                  textColor: ColorSchemes.white),
            ),
            SizedBox(
              height: 16.h,
            ),
          ],
        ),
      ),
    );
  }
}
