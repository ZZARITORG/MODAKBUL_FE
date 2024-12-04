import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/utils/date_time_utils.dart';

class CustomTimePicker extends StatefulWidget {
  @override
  _CustomTimePickerState createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  String? selectedPeriod;
  int? selectedHour;
  int? selectedMinute;
  DateTime? currentTime;

  @override
  void initState() {
    super.initState();
    _initializeTime();
  }

  Future<void> _initializeTime() async {
    DateTime koreaTime = await DateTimeUtils.getKoreaTime();
    setState(() {
      currentTime = koreaTime.add(Duration(minutes: 300));
      selectedHour = currentTime!.hour % 12 == 0 ? 12 : currentTime!.hour % 12;
      selectedMinute = currentTime!.minute;
      selectedPeriod = currentTime!.hour >= 12 ? '오후' : '오전';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentTime == null) return const SizedBox.shrink();

    int currentHour24 = currentTime!.hour;
    String currentPeriod = currentHour24 >= 12 ? '오후' : '오전';
    int currentHour12 = currentHour24 % 12 == 0 ? 12 : currentHour24 % 12;
    int currentMinute = currentTime!.minute;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // AM/PM Picker
              Container(
                width: 60.w,
                height: 150.h,
                child: ListWheelScrollView.useDelegate(
                  itemExtent: 50.h,
                  physics: FixedExtentScrollPhysics(),
                  controller: FixedExtentScrollController(
                      initialItem: currentPeriod == '오전' ? 0 : 1),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedPeriod = index == 0 ? '오전' : '오후';
                    });
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      String period = index == 0 ? '오전' : '오후';
                      bool isSelectable = true;

                      if (currentPeriod == '오후' && period == '오전') {
                        isSelectable = false;
                      }

                      return Center(
                        child: Text(
                          period,
                          style: Theme.of(context).textTheme.bigHeadLine3.copyWith(
                            color: isSelectable
                                ? (selectedPeriod == period
                                ? ColorSchemes.orange200
                                : ColorSchemes.orange100)
                                : ColorSchemes.gray300,
                          ),
                        ),
                      );
                    },
                    childCount: 2,
                  ),
                ),
              ),
              SizedBox(width: 10),
              // Hour Picker
              Container(
                width: 60.w,
                height: 150.h,
                child: ListWheelScrollView.useDelegate(
                  itemExtent: 50.h,
                  physics: FixedExtentScrollPhysics(),
                  controller: FixedExtentScrollController(
                      initialItem: selectedHour! - 1),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedHour = index + 1; // 1부터 12시까지
                    });
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      int hour = index + 1;
                      bool isSelectable = true;

                      // 오전 선택 시, 모든 시간 비활성화
                      if (selectedPeriod == '오전' && currentPeriod == '오후') {
                        isSelectable = false;
                      }

                      // 현재 시간과 비교하여 비활성화 처리
                      if (selectedPeriod == currentPeriod) {
                        if (hour < currentHour12) {
                          isSelectable = false;
                        }
                      }

                      return Center(
                        child: Text(
                          '$hour',
                          style: Theme.of(context).textTheme.bigHeadLine3.copyWith(
                            color: isSelectable
                                ? (selectedHour == hour
                                ? ColorSchemes.orange200
                                : ColorSchemes.orange100)
                                : ColorSchemes.gray300,
                          ),
                        ),
                      );
                    },
                    childCount: 12,
                  ),
                ),
              ),
              SizedBox(width: 10),
              // Minute Picker
              Container(
                width: 60.w,
                height: 150.h,
                child: ListWheelScrollView.useDelegate(
                  itemExtent: 50,
                  physics: FixedExtentScrollPhysics(),
                  controller: FixedExtentScrollController(
                      initialItem: selectedMinute!),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedMinute = index;
                    });
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      bool isSelectable = true;

                      // 오전 선택 시, 모든 분 비활성화
                      if (selectedPeriod == '오전' && currentPeriod == '오후') {
                        isSelectable = false;
                      }

                      // 기준 시간과 분 기준 비활성화 처리
                      if (selectedPeriod == currentPeriod &&
                          selectedHour == currentHour12 &&
                          index < currentMinute) {
                        isSelectable = false;
                      }

                      // 이전 시간에 대해 모든 분 비활성화
                      if (selectedPeriod == currentPeriod &&
                          selectedHour! < currentHour12) {
                        isSelectable = false;
                      }

                      return Center(
                        child: Text(
                          '${index.toString().padLeft(2, '0')}',
                          style: Theme.of(context).textTheme.bigHeadLine3.copyWith(
                            color: isSelectable
                                ? (selectedMinute == index
                                ? ColorSchemes.orange200
                                : ColorSchemes.orange100)
                                : ColorSchemes.gray300,
                          ),
                        ),
                      );
                    },
                    childCount: 60,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'Selected Time: ${selectedHour}:${selectedMinute.toString().padLeft(2, '0')} $selectedPeriod',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
