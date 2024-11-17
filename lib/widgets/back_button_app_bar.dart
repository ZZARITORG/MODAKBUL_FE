import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';

class BackButtonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isActionButton;
  final VoidCallback? onActionPressed;
  final Color? backgroundColor;

  const BackButtonAppBar(
      {Key? key, this.backgroundColor, this.isActionButton = false, this.onActionPressed})
      : super(key: key);

  factory BackButtonAppBar.actions({required VoidCallback onActionPressed, required Color backgroundColor}) =>
      BackButtonAppBar(
        backgroundColor: backgroundColor,
        isActionButton: true,
        onActionPressed: onActionPressed,
      );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: backgroundColor,
      ///스타일로 옮기기
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: EdgeInsets.only(left: StyleConstants.defaultPadding),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => Navigator.pop(context),
              icon: SvgPicture.asset(
                IconPath.arrowBack,
                height: 22.r, // 반응형 높이
                width: 22.r, fit: BoxFit.scaleDown,
              )),
        ]),
      ),
      actions: [
        if (isActionButton)
          Padding(
            padding: EdgeInsets.only(right: StyleConstants.defaultPadding),
            child: SizedBox(
              height: 24.r,
              width: 24.r,
              child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onActionPressed,
                  icon: SvgPicture.asset(
                    IconPath.moreHorizontal,
                    width: 20.r,
                    fit: BoxFit.scaleDown,
                  )),
            ),
          ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight.h);
}
