import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';

class CreateMeetingButton extends StatelessWidget {
  final String type;
  final String content;
  final VoidCallback? onPressed;
  final String icon;

  const CreateMeetingButton({
    Key? key,
    required this.type,
    required this.content,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 361.w,
      height: 62.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14), color: Colors.white),
      padding: EdgeInsets.fromLTRB(16.w, 17.h, 16.w, 17.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 28.w,
                height: 28.h,
              ),
              Text(
                type,
                style: Theme.of(context)
                    .textTheme
                    .smallHeadLine2
                    .copyWith(color: ColorSchemes.gray400),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onPressed,
                  icon: SvgPicture.asset('assets/icons/dd')),
              Text(
                content,
                style: Theme.of(context)
                    .textTheme
                    .smallHeadLine3
                    .copyWith(color: ColorSchemes.orange200),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
