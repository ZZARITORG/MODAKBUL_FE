import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:modakbul/constants/app_constants.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/models/modakbul_by_group_id.dart';
import 'package:modakbul/models/modakbul_by_user_id.dart';
import 'package:modakbul/providers/meeting_provider.dart';
import 'package:modakbul/routes/routes.dart';
import 'package:modakbul/services/meeting_service.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/utils/date_time_utils.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/content_info.dart';
import 'package:modakbul/widgets/custom_button.dart';
import 'package:modakbul/widgets/custom_calender_picker.dart';
import 'package:modakbul/widgets/custom_time_picker.dart';
import 'package:modakbul/widgets/custom_toast.dart';
import 'package:provider/provider.dart';

class CreateContentScreen extends StatefulWidget {
  const CreateContentScreen({super.key});

  @override
  _CreateContentScreenState createState() => _CreateContentScreenState();
}

class _CreateContentScreenState extends State<CreateContentScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool isActivated = false;
  bool isButtonDisabled = false;
  int _contentLength = 0;
  late MeetingProvider meetingProvider;
  MeetingService meetingService = MeetingService();
  String uuid = '';

  // 문자 수를 정확하게 계산하는 메서드
  int getCharacterCount(String text) {
    return text.characters.length; // length 대신 characters 사용
  }

  void _updateActivationState() {
    setState(() {
      isActivated = _titleController.text.isNotEmpty &&
          _contentController.text.isNotEmpty;
    });
  }

  DateTime combineTimeWithDate(DateTime date, String hour, String minute) {
    int hourInt = int.parse(hour);
    int minuteInt = int.parse(minute);
    int secondInt = 00;
    int millisecondInt = 000;

    return DateTime(date.year, date.month, date.day, hourInt, minuteInt,
        secondInt, millisecondInt);
  }

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_updateActivationState);
    _contentController.addListener(() {
      setState(() {
        _contentLength = getCharacterCount(_contentController.text);
        // 최대 길이를 초과하는 문자 자동 제거
        if (_contentLength > AppConstants.maxContentLength) {
          final trimmedText = _contentController.text.characters
              .take(AppConstants.maxContentLength)
              .toString();
          _contentController.value = TextEditingValue(
            text: trimmedText,
            selection: TextSelection.collapsed(offset: trimmedText.length),
          );
          _contentLength = AppConstants.maxContentLength;
        }
        _updateActivationState();
      });
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    meetingProvider = Provider.of<MeetingProvider>(context, listen: true);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorSchemes.gray000,
      appBar: const BackButtonAppBar(
        backgroundColor: ColorSchemes.gray000,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: StyleConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(height: 24.h),
                          Stack(
                            children: [
                              TextField(
                                controller: _titleController,
                                maxLength: AppConstants.maxTitleLength,
                                cursorColor: ColorSchemes.orange100,
                                onTapOutside: (event) => FocusManager
                                    .instance.primaryFocus
                                    ?.unfocus(),
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                style: Theme.of(context)
                                    .textTheme
                                    .bigHeadLine2
                                    .copyWith(
                                      color: ColorSchemes.gray500,
                                    ),
                                decoration: InputDecoration(
                                  counterText: '',
                                  hintText: '제목을 입력해 주세요',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bigHeadLine2
                                      .copyWith(color: ColorSchemes.gray200),
                                  isDense: true,
                                  contentPadding:
                                      EdgeInsets.only(left: 4.w, bottom: 6.h),
                                  border: InputBorder.none,
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
                                    borderRadius: BorderRadius.circular(2.r),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          SizedBox(
                            height: 272.h,
                            child: TextField(
                              controller: _contentController,
                              maxLines: null,
                              maxLength: AppConstants.maxContentLength,
                              cursorColor: ColorSchemes.orange100,
                              onTapOutside: (event) =>
                                  FocusManager.instance.primaryFocus?.unfocus(),
                              keyboardType: TextInputType.multiline,
                              style: Theme.of(context).textTheme.body1.copyWith(
                                    color: ColorSchemes.gray500,
                                  ),
                              decoration: InputDecoration(
                                counterText: '',
                                hintText: '내용을 입력하고 모닥불을 피워보세요.',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .body1
                                    .copyWith(color: ColorSchemes.gray200),
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.only(left: 4.w, bottom: 6.h),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Padding(
                            padding: EdgeInsets.only(right: 4.w),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '$_contentLength',
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(
                                          color:
                                              _contentController.text.isNotEmpty
                                                  ? ColorSchemes.orange200
                                                  : ColorSchemes.gray200,
                                        ),
                                  ),
                                  TextSpan(
                                    text: ' /${AppConstants.maxContentLength}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(
                                          color: ColorSchemes.gray200,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    onTap: () => Routes.navigateTo(context, Routes.groupSelectScreen),
                    child: ContentInfo(
                      info: meetingProvider.selectGroupName ?? ' ',
                      onPressed: () {},
                      icon: IconPath.groupOrange200,
                      isActivated: true,
                      iconWidth: 18.r,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  InkWell(
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    onTap: () => Routes.navigateTo(context, Routes.mapSearchScreen),
                    child: ContentInfo(
                      info: meetingProvider.selectPlace ?? ' ',
                      onPressed: () {},
                      icon: IconPath.pinDropOrange200,
                      isActivated: true,
                      iconWidth: 16.r,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  InkWell(
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    onTap: () => showModalBottomSheet(
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
                    child: ContentInfo(
                      info:
                          DateFormat('M월 d일').format(meetingProvider.selectDate ?? DateTime(1999, 1, 1)),
                      onPressed: () {},
                      icon: IconPath.calendarMonthOrange200,
                      isActivated: true,
                      iconWidth: 16.r,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  InkWell(
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    onTap: () {
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
                    },
                    child: ContentInfo(
                      info:
                          meetingProvider.selectHour != null || meetingProvider.selectMinute != null ? '${meetingProvider.selectHour ?? ' '}시 ${meetingProvider.selectMinute ?? ' '!.padLeft(2, '0')}분' : '시간 선택',
                      onPressed: () {},
                      icon: meetingProvider.selectHour != null || meetingProvider.selectMinute != null
                          ? IconPath.timeOrange200
                          : IconPath.timeOrange100,
                      isActivated: meetingProvider.selectHour != null || meetingProvider.selectMinute != null,
                      iconWidth: 18.r,
                    ),
                  ),
                  SizedBox(
                    height: 100.h,
                  )
                ],
              ),
            ),
            Positioned(
              left: StyleConstants.defaultPadding,
              right: StyleConstants.defaultPadding,
              bottom: bottomInset > 0 ? bottomInset + 16.h : 16.h,
              child: SizedBox(
                height: 56.h,
                child: CustomButton(
                  text: '게시하기',
                  onPressed: isActivated && !isButtonDisabled
                      ? () async {
                          if (meetingProvider.selectHour != null || meetingProvider.selectMinute != null) {
                            try {
                              setState(() {
                                isButtonDisabled = true;
                              });
                              DateTime now = await DateTimeUtils.getKoreaTime();
                              DateTime selectDateTime = combineTimeWithDate(
                                  meetingProvider.selectDate!,
                                  meetingProvider.selectHour!,
                                  meetingProvider.selectMinute!);
                              if(selectDateTime.isAfter(now)) {
                                if (meetingProvider.isGroup!) {
                                  uuid = await meetingService.createModakbulByGroupId(
                                      ModakbulByGroupId(
                                          title: _titleController.text,
                                          content: _contentController.text,
                                          location: meetingProvider.selectPlace!,
                                          address: meetingProvider.selectAddress!,
                                          detailAddress:
                                          meetingProvider.selectDetailAddress!,
                                          date: selectDateTime,
                                          lat: meetingProvider.selectLat!,
                                          lng: meetingProvider.selectLng!,
                                          groupId: meetingProvider.selectGroupId!));
                                } else {
                                  List<String> selectFriends = meetingProvider.selectFriends!
                                      .map((friend) =>
                                  friend['id'] as String)
                                      .toList();
                                  meetingProvider.isGroup = false;
                                  uuid = await meetingService.createModakbulByUserId(
                                      ModakbulByUserId(
                                          title: _titleController.text,
                                          content: _contentController.text,
                                          location: meetingProvider.selectPlace!,
                                          address: meetingProvider.selectAddress!,
                                          detailAddress:
                                          meetingProvider.selectDetailAddress!,
                                          date: selectDateTime,
                                          lat: meetingProvider.selectLat!,
                                          lng: meetingProvider.selectLng!,
                                          friendIds: selectFriends));
                                }
                                Routes
                                    .navigateReplacement(
                                    context,
                                    Routes
                                        .modakbulDetailScreen,
                                    arguments: {
                                      'id': uuid,
                                      'isAccepted':
                                      true,
                                    });
                                meetingProvider.reset();
                                setState(() {
                                  isButtonDisabled = false;
                                });
                              } else {
                                CustomToast.showToast(context, '선택한 시간이 현재시간보다 빠릅니다.', false);
                              }
                            } catch (e) {
                              CustomToast.showToast(context, '모닥불 생성을 실패했습니다.', false);
                            }
                          } else {
                            CustomToast.showToast(context, '시간이 선택되지 않았습니다.', false);
                          }
                        }
                      : null,
                  buttonColor: ColorSchemes.orange200,
                  textStyle:
                      Theme.of(context).textTheme.smallHeadLine2.copyWith(
                            color: ColorSchemes.white,
                          ),
                  textColor: ColorSchemes.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
