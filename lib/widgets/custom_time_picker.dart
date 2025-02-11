import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/providers/meeting_provider.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/utils/date_time_utils.dart';
import 'package:provider/provider.dart';

import 'custom_button.dart';

class CustomTimePicker extends StatefulWidget {
  final DateTime selectedDate;

  CustomTimePicker({required this.selectedDate});

  @override
  _CustomTimePickerState createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  String? selectedPeriod;
  int? selectedHour;
  int? selectedMinute;
  DateTime? currentTime;
  late bool isPeriodDisabled;
  late bool isHourDisabled;
  late bool isMinuteDisabled;
  late MeetingProvider meetingProvider;

  @override
  void initState() {
    super.initState();
    _initializeTime();
  }

  Future<void> _initializeTime() async {
    DateTime koreaTime = await DateTimeUtils.getKoreaTime();
    setState(() {
      MeetingProvider meetingProvider = Provider.of<MeetingProvider>(context, listen: false);
      currentTime = koreaTime;

      bool isToday = widget.selectedDate.year == currentTime!.year &&
          widget.selectedDate.month == currentTime!.month &&
          widget.selectedDate.day == currentTime!.day;

      Duration difference = widget.selectedDate.difference(currentTime!);

      if (isToday) {
        // 오늘 날짜일 경우 최소 선택 가능 시간 = 현재 시간 + 1시간
        currentTime = currentTime!.add(const Duration(hours: 1));
      }

      // 1시간 미만일 경우 최소 시간 기준 설정
      if (!isToday && difference.inMinutes < 60) {
        currentTime = currentTime!.add(const Duration(hours: 1));
      }

      if (!isToday && difference.inMinutes > 60) {
        currentTime = DateTime(currentTime!.year, currentTime!.month,
            currentTime!.day, 0, 0);
      }


      selectedHour = meetingProvider.selectHour != null ? int.tryParse(meetingProvider.selectHour!) : currentTime!.hour;
      selectedMinute = meetingProvider.selectMinute != null ? int.tryParse(meetingProvider.selectMinute!) : currentTime!.minute;
      selectedPeriod = currentTime!.hour >= 12 ? '오후' : '오전';
    });
  }

  bool isMinuteSelectable(int minute) {
    return !((selectedHour == currentTime!.hour && minute < currentTime!.minute)
        || (selectedHour! < currentTime!.hour));
  }

  @override
  Widget build(BuildContext context) {
    meetingProvider = Provider.of<MeetingProvider>(context, listen: false);
    if (currentTime == null) return const SizedBox.shrink();

    final isAfternoon = currentTime!.hour >= 12;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // AM/PM Picker
              Container(
                width: 54.w,
                height: 150.h,
                child: ListWheelScrollView.useDelegate(
                  itemExtent: 50.h,
                  physics: const FixedExtentScrollPhysics(),
                  controller: FixedExtentScrollController(
                      initialItem: selectedPeriod == '오전' ? 0 : 1),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedPeriod = index == 0 ? '오전' : '오후';
                      selectedHour = selectedPeriod == '오전' ? selectedHour! % 12 : selectedHour! + 12;
                    });
                  },
                  childDelegate: ListWheelChildListDelegate(
                    children: ['오전', '오후']
                        .map(
                          (period) {
                            isPeriodDisabled = isAfternoon && period == '오전';

                        return Center(
                          child: Text(
                            period,
                            style: Theme.of(context).textTheme.bigHeadLine3.copyWith(
                              color: isPeriodDisabled
                                  ? ColorSchemes.gray300 // 비활성화된 상태
                                  : selectedPeriod == period
                                  ? ColorSchemes.orange200 // 선택된 항목
                                  : ColorSchemes.orange100, // 기본 상태
                            ),
                          ),
                        );
                      },
                    )
                        .toList(),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              // Hour Picker
              Container(
                width: 54.w,
                height: 150.h,
                child: ListWheelScrollView.useDelegate(
                  itemExtent: 50.h,
                  physics: const FixedExtentScrollPhysics(),
                  controller: FixedExtentScrollController(
                      initialItem: selectedHour!),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      ///12시 일경우 0으로 바꿔야댐
                      selectedHour = selectedPeriod == '오전' ? index : index + 12;  // 1부터 12까지
                      print(isHourDisabled);
                    });
                  },
                  childDelegate: ListWheelChildLoopingListDelegate(
                    children: List.generate(12, (index) {
                      final hours = [12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
                      int hour = selectedPeriod == '오전' ? index : index + 12;
                      isHourDisabled = (selectedPeriod == '오전' && isAfternoon) || // 오후일 때 오전 비활성화
                          (hour < currentTime!.hour);

                      return Center(
                        child: Text(
                          '${hours[index]}',
                          style: Theme
                              .of(context)
                              .textTheme
                              .bigHeadLine3
                              .copyWith(
                            color: isHourDisabled
                                ? ColorSchemes.gray300
                                : selectedHour == hour
                                ? ColorSchemes.orange200
                                : ColorSchemes.orange100,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              // Minute Picker
              Container(
                width: 54.w,
                height: 150.h,
                child: ListWheelScrollView.useDelegate(
                  itemExtent: 50.h,
                  physics: const FixedExtentScrollPhysics(),
                  controller: FixedExtentScrollController(
                      initialItem: selectedMinute!),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedMinute = index % 60;
                    });
                  },
                  childDelegate: ListWheelChildLoopingListDelegate(
                    children: List.generate(60, (index) {
                      int minute = index % 60;
                      isMinuteDisabled = (selectedHour == currentTime!.hour && minute < currentTime!.minute)
                          || (selectedHour! < currentTime!.hour);

                      return Center(
                        child: Text(
                          index.toString().padLeft(2, '0'),
                          style: Theme
                              .of(context)
                              .textTheme
                              .bigHeadLine3
                              .copyWith(
                            color: isMinuteDisabled
                                ? ColorSchemes.gray300
                                : selectedMinute == index
                                ? ColorSchemes.orange200
                                : ColorSchemes.orange100,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 34.h),
          SizedBox(
            height: 56.h,
            width: double.infinity,
            child: CustomButton(
              text: '$selectedHour시 ${selectedMinute.toString().padLeft(
                  2, '0')}분 등록',
               onPressed: isMinuteSelectable(selectedMinute!) ? () {
                 //widget.onTimeSelected(selectedHour!.toString(), selectedMinute!.toString());
                 meetingProvider.selectHour = selectedHour!.toString();
                 meetingProvider.selectMinute = selectedMinute!.toString();
                  Navigator.pop(context);
              } : null,
              buttonColor: ColorSchemes.orange200,
              textStyle: Theme.of(context).textTheme.smallHeadLine2,
              textColor: ColorSchemes.white,
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}