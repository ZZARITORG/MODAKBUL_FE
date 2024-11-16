import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modakbul/constants/assets_path.dart';

class CustomCheckbox extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool> onChanged;

  const CustomCheckbox({
    Key? key,
    required this.isChecked,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 24.r,
          width: 24.r,
          child: IconButton(
            onPressed: () => onChanged(!isChecked),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: SvgPicture.asset(
              isChecked
                  ? IconPath.checkCircleActivate
                  : IconPath.checkCircleDisabled,
              width: 24.r,
              height: 24.r,
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
      ],
    );
  }
}
