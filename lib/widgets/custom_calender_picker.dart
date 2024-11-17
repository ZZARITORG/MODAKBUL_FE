import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';

import 'custom_button.dart';

class CustomCalendarPicker extends StatefulWidget {

  @override
  _CustomCalendarPickerState createState() => _CustomCalendarPickerState();
}

class _CustomCalendarPickerState extends State<CustomCalendarPicker> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  List<String> weekdays = ['일', '월', '화', '수', '목', '금', '토'];

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  void _onPreviousMonth() {
    if (_focusedDate.month > DateTime.now().month || _focusedDate.year > DateTime.now().year) {
      setState(() {
        _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1);
      });
    }
  }

  void _onNextMonth() {
    setState(() {
      _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1);
    });
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month, 1);
    final firstWeekdayOffset = firstDayOfMonth.weekday % 7;
    final lastDayOfMonth = DateUtils.getDaysInMonth(_focusedDate.year, _focusedDate.month);
    final today = _dateOnly(DateTime.now());

    final totalItems = firstWeekdayOffset + lastDayOfMonth;
    //final rows = ((totalItems + 6) ~/ 7); // 필요한 행의 수 계산

    return Column(
      mainAxisSize: MainAxisSize.min, // Column이 필요한 만큼만 공간 차지하도록 설정
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('M월').format(_focusedDate),
              style: Theme.of(context)
                  .textTheme
                  .bigHeadLine2
                  .copyWith(color: ColorSchemes.orange200),
            ),
            Row(
              children: [
                Visibility(
                  visible: _focusedDate.month > DateTime.now().month || _focusedDate.year > DateTime.now().year,
                  child: SizedBox(
                    height: 28.r,
                    width: 28.r,
                    child: IconButton(
                      icon: SvgPicture.asset(IconPath.dateArrowBack, width: 10.r),
                      onPressed: _onPreviousMonth,
                    ),
                  ),
                ),
                SizedBox(width: 24.w),
                SizedBox(
                  height: 28.r,
                  width: 28.r,
                  child: IconButton(
                    icon: SvgPicture.asset(IconPath.dateArrowForward, width: 10.r),
                    onPressed: _onNextMonth,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 22.h,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: weekdays.map((day) {
            return SizedBox(
              height: 42.r,
              width: 42.r,
              child: Center(
                child: Text(
                  day,
                  style: Theme.of(context)
                      .textTheme
                      .body3
                      .copyWith(color: ColorSchemes.gray300),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 5.w),
        // GridView를 SizedBox로 감싸고 정확한 높이 지정
        SizedBox(
          height: 6 * 56.r, // 각 행의 높이(42.r + 14.h의 spacing)
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(), // 스크롤 비활성화
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 14.h,
              crossAxisSpacing: 11.w,
              childAspectRatio: 1,
              mainAxisExtent: 42.r,
            ),
            itemCount: totalItems,
            itemBuilder: (context, index) {
              DateTime date;
              TextStyle textStyle;

              if (index < firstWeekdayOffset) {
                return Container();
              } else {
                date = DateTime(_focusedDate.year, _focusedDate.month,
                    index - firstWeekdayOffset + 1);
                textStyle = _dateOnly(date).isBefore(today)
                    ? Theme.of(context)
                    .textTheme
                    .body2
                    .copyWith(color: ColorSchemes.gray300)
                    : Theme.of(context)
                    .textTheme
                    .body2
                    .copyWith(color: ColorSchemes.orange100);
              }

              final isSelected = _dateOnly(date) == _dateOnly(_selectedDate);
              final isSelectable = !_dateOnly(date).isBefore(today);

              return GestureDetector(
                onTap: isSelectable ? () => _onDateSelected(date) : null,
                child: Container(
                  width: 42.r,
                  height: 42.r,
                  decoration: isSelected
                      ? const BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorSchemes.orange200,
                  )
                      : null,
                  child: Center(
                    child: Text(
                      '${date.day}',
                      style: textStyle.copyWith(
                          color: isSelected ? ColorSchemes.white : textStyle.color),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 56.h,
          width: double.infinity,
          child: CustomButton(
              text: _selectedDate.toString(),
              onPressed: () {},
              buttonColor: ColorSchemes.orange200,
              textStyle:
              Theme.of(context).textTheme.smallHeadLine2,
              textColor: ColorSchemes.white),
        ),
        SizedBox(
          height: 16.h,
        ),
      ],
    );
  }
}