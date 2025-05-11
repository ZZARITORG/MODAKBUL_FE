import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/providers/meeting_provider.dart';
import 'package:modakbul/routes/routes.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/create_meeting_button.dart';
import 'package:modakbul/widgets/custom_button.dart';
import 'package:modakbul/widgets/custom_calender_picker.dart';
import 'package:modakbul/widgets/custom_time_picker.dart';
import 'package:modakbul/widgets/custom_toast.dart';
import 'package:modakbul/widgets/logo_app_bar.dart';
import 'package:provider/provider.dart';

class CreateModakbulScreen extends StatefulWidget {
  const CreateModakbulScreen({super.key});

  @override
  State<CreateModakbulScreen> createState() => _CreateModakbulScreenState();
}

class _CreateModakbulScreenState extends State<CreateModakbulScreen> {
  //String? selectAddress;
  DateTime? selectDate;
  String? selectHour;
  String? selectMinute;
  late MeetingProvider meetingProvider;

  /*void _onAddressSelected(String address) {
    setState(() {
      selectAddress = address;
      print('selectDate: $selectDate');
    });
  }*/

  void _onDateSelected(DateTime date) {
    setState(() {
      selectDate = date;
      print('selectDate: $selectDate');
    });
  }

  void _onTimeSelected(String hour, String minute) {
    setState(() {
      selectHour = hour;
      selectMinute = minute;
    });
  }

  bool isActivated() {
    return meetingProvider.selectGroupName != null &&
        meetingProvider.selectPlace != null &&
        meetingProvider.selectDate != null &&
        meetingProvider.selectHour != null &&
        meetingProvider.selectMinute != null;
  }

  int convertTo12Hour(int hour) {
    if (hour == 0) return 12; // 00시는 12시로 변환
    if (hour > 12) return hour - 12; // 13~23시는 1~11시로 변환
    return hour; // 1~12시는 그대로 반환
  }

  String getAmPm(int hour) {
    return hour < 12 ? '오전' : '오후';
  }

  @override
  Widget build(BuildContext context) {
    meetingProvider = Provider.of<MeetingProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorSchemes.gray000,
      appBar: const LogoAppBar(
        backgroundColor: ColorSchemes.gray000,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 128.h ,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          height: 24.h,
                        ),
                        SizedBox(
                            width: 322.w,
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                '모닥불을 피우기 전\n상세정보를 선택해 주세요',
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
                          '다음으로 넘어가기 전 아래 항목을 선택해 주세요.',
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
                          content: meetingProvider.selectGroupName != null
                              ? meetingProvider.selectGroupName!
                              : '그룹 선택',
                          onPressed: () =>
                              Routes.navigateTo(context, Routes.groupSelectScreen),
                          icon: meetingProvider.selectGroupName != null
                              ? IconPath.groupOrange200
                              : IconPath.groupOrange100,
                          typeColor: meetingProvider.selectGroupName != null
                              ? ColorSchemes.orange200
                              : ColorSchemes.orange100,
                          contentColor: meetingProvider.selectGroupName != null
                              ? ColorSchemes.orange100
                              : ColorSchemes.gray200,
                          arrowIcon: meetingProvider.selectGroupName != null
                              ? IconPath.arrowForward15Orange100
                              : IconPath.arrowForward15Gray200,
                          iconWidth: 20.r,
                        ),
                        SizedBox(
                          height: 14.h,
                        ),
                        CreateMeetingButton(
                          type: '위치',
                          content: meetingProvider.selectPlace != null
                              ? meetingProvider.selectPlace!
                              : '위치 선택',
                          onPressed: () =>
                              Routes.navigateTo(context, Routes.mapSearchScreen),
                          icon: meetingProvider.selectPlace != null
                              ? IconPath.pinDropOrange200
                              : IconPath.pinDropOrange100,
                          typeColor: meetingProvider.selectPlace != null
                              ? ColorSchemes.orange200
                              : ColorSchemes.orange100,
                          contentColor: meetingProvider.selectPlace != null
                              ? ColorSchemes.orange100
                              : ColorSchemes.gray200,
                          arrowIcon: meetingProvider.selectPlace != null
                              ? IconPath.arrowForward15Orange100
                              : IconPath.arrowForward15Gray200,
                          iconWidth: 16.r,
                        ),
                        SizedBox(
                          height: 14.h,
                        ),
                        CreateMeetingButton(
                          type: '날짜',
                          content: meetingProvider.selectDate != null
                              ? DateFormat('M월 d일').format(meetingProvider.selectDate!)
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
                                        CustomCalendarPicker(),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                          icon: meetingProvider.selectDate != null
                              ? IconPath.calendarMonthOrange200
                              : IconPath.calendarMonthOrange100,
                          typeColor: meetingProvider.selectDate != null
                              ? ColorSchemes.orange200
                              : ColorSchemes.orange100,
                          contentColor: meetingProvider.selectDate != null
                              ? ColorSchemes.orange100
                              : ColorSchemes.gray200,
                          arrowIcon: meetingProvider.selectDate != null
                              ? IconPath.arrowForward15Orange100
                              : IconPath.arrowForward15Gray200,
                          iconWidth: 19.r,
                        ),
                        SizedBox(
                          height: 14.h,
                        ),
                        CreateMeetingButton(
                          type: '시간',
                          content: meetingProvider.selectHour != null &&
                              meetingProvider.selectMinute != null
                              ? '${getAmPm(int.parse(meetingProvider.selectHour!))} ${convertTo12Hour(int.parse(meetingProvider.selectHour!))}:${meetingProvider.selectMinute!.padLeft(2, '0')}'
                              : '시간 선택',
                          onPressed: () {
                            if (meetingProvider.selectDate != null) {
                              showModalBottomSheet(
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
                                            CustomTimePicker(
                                                selectedDate: meetingProvider.selectDate!),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            } else {
                              CustomToast.showToast(context, '날짜를 먼저 선택해주세요.', false, customBottom: 86.h);
                            }
                          },
                          icon: meetingProvider.selectHour != null &&
                              meetingProvider.selectMinute != null
                              ? IconPath.timeOrange200
                              : IconPath.timeOrange100,
                          typeColor: meetingProvider.selectHour != null &&
                              meetingProvider.selectMinute != null
                              ? ColorSchemes.orange200
                              : ColorSchemes.orange100,
                          contentColor: meetingProvider.selectHour != null &&
                              meetingProvider.selectMinute != null
                              ? ColorSchemes.orange100
                              : ColorSchemes.gray200,
                          arrowIcon: meetingProvider.selectHour != null &&
                              meetingProvider.selectMinute != null
                              ? IconPath.arrowForward15Orange100
                              : IconPath.arrowForward15Gray200,
                          iconWidth: 20.r,
                        ),
                      ],
                    ),
                  ),
                ),
          ),
          Positioned(
            bottom: 16.h,
            left: 16.w,
            right: 16.w,
            child: SizedBox(
              height: 56.h,
              width: double.infinity,
              child: CustomButton(
                  text: '선택완료',
                  onPressed: isActivated()
                      ? () =>
                      Routes.navigateTo(context, Routes.createContentScreen)
                      : null,
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