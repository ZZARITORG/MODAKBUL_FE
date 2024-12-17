import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/utils/date_time_utils.dart';

import 'custom_button.dart';

class CustomCalendarPicker extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const CustomCalendarPicker({required this.onDateSelected, Key? key})
      : super(key: key);

  @override
  State<CustomCalendarPicker> createState() => _CustomCalendarPickerState();
}

class _CustomCalendarPickerState extends State<CustomCalendarPicker> {
  DateTime? _selectedDate;
  DateTime? _focusedDate;
  DateTime? _today;
  DateTime? _limitDate;
  List<String> weekdays = ['일', '월', '화', '수', '목', '금', '토'];

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  void _onPreviousMonth() {
    if (_canGoToPreviousMonth()) {
      setState(() {
        _focusedDate = DateTime(_focusedDate!.year, _focusedDate!.month - 1);
      });
    }
  }

  void _onNextMonth() {
    if (_canGoToNextMonth()) {
      setState(() {
        _focusedDate = DateTime(_focusedDate!.year, _focusedDate!.month + 1);
      });
    }
  }

  bool _canGoToPreviousMonth() {
    if (_today == null || _focusedDate == null) return false;
    return _focusedDate!.month > _today!.month ||
        _focusedDate!.year > _today!.year;
  }

  bool _canGoToNextMonth() {
    if (_today == null || _limitDate == null) return false;
    return _focusedDate!.month < _limitDate!.month ||
        _focusedDate!.year < _limitDate!.year;
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  Future<void> _initializeFocusedDate() async {
    _today = await DateTimeUtils.getKoreaTime();
    DateTime todayEnd = DateTime(_today!.year, _today!.month, _today!.day, 23, 0);
    final lastHourStart = todayEnd.subtract(const Duration(hours: 1));

    if (_today!.isAfter(lastHourStart)) {
      _today = _today!.add(const Duration(days: 1));
    }

    _limitDate = _today!.add(const Duration(days: 30));
    _focusedDate = _today;
    _selectedDate = _today;
    setState(() {});
  }

  bool _isDateSelectable(DateTime date) {
    if (_today == null || _limitDate == null) return false;

    final today = _dateOnly(_today!);
    final limitDate = _dateOnly(_limitDate!);
    final targetDate = _dateOnly(date);

    return !targetDate.isBefore(today) && !targetDate.isAfter(limitDate);
  }

  @override
  void initState() {
    super.initState();
    _initializeFocusedDate();
  }

  @override
  Widget build(BuildContext context) {
    if (_focusedDate == null && _selectedDate == null) {
      return const SizedBox.shrink();
    }

    final firstDayOfMonth = DateTime(_focusedDate!.year, _focusedDate!.month, 1);
    final firstWeekdayOffset = firstDayOfMonth.weekday % 7;
    final lastDayOfMonth = DateUtils.getDaysInMonth(_focusedDate!.year, _focusedDate!.month);

    final totalItems = firstWeekdayOffset + lastDayOfMonth;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('M월').format(_focusedDate!),
              style: Theme.of(context)
                  .textTheme
                  .bigHeadLine2
                  .copyWith(color: ColorSchemes.orange200),
            ),
            Row(
              children: [
                Visibility(
                  visible: _canGoToPreviousMonth(),
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
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
                Visibility(
                  visible: _canGoToNextMonth(),
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: SizedBox(
                    height: 28.r,
                    width: 28.r,
                    child: IconButton(
                      icon: SvgPicture.asset(IconPath.dateArrowForward, width: 10.r),
                      onPressed: _onNextMonth,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 22.h),
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
        SizedBox(
          height: 6 * 56.r,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 14.h,
              crossAxisSpacing: 11.w,
              childAspectRatio: 1,
              mainAxisExtent: 42.r,
            ),
            itemCount: totalItems,
            itemBuilder: (context, index) {
              if (index < firstWeekdayOffset) {
                return Container();
              }

              final date = DateTime(_focusedDate!.year, _focusedDate!.month, index - firstWeekdayOffset + 1);
              final isSelectable = _isDateSelectable(date);
              final isSelected = _dateOnly(date) == _dateOnly(_selectedDate!);

              TextStyle textStyle = isSelectable
                  ? Theme.of(context)
                  .textTheme
                  .body2
                  .copyWith(color: ColorSchemes.orange100)
                  : Theme.of(context)
                  .textTheme
                  .body2
                  .copyWith(color: ColorSchemes.gray300);

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
                          color: isSelected
                              ? ColorSchemes.white
                              : textStyle.color),
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
            text: '${DateFormat('M월 d일').format(_selectedDate!)} 등록',
            onPressed: () {
              if (_isDateSelectable(_selectedDate!)) {
                widget.onDateSelected(_selectedDate!);
                Navigator.pop(context);
              }
            },
            buttonColor: _isDateSelectable(_selectedDate!)
                ? ColorSchemes.orange200
                : ColorSchemes.gray300,
            textStyle: Theme.of(context).textTheme.smallHeadLine2,
            textColor: ColorSchemes.white,
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}