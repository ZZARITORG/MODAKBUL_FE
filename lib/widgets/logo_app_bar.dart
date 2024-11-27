import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';

class LogoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isActionButton;
  final VoidCallback? onActionPressed;
  final Color? backgroundColor;

  const LogoAppBar(
      {Key? key, this.backgroundColor,this.isActionButton = false, this.onActionPressed})
      : super(key: key);

  factory LogoAppBar.actions({required VoidCallback onActionPressed}) =>
      LogoAppBar(
        isActionButton: true,
        onActionPressed: onActionPressed,
      );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: backgroundColor,
      ///스타일 폴더로 옮기기
      automaticallyImplyLeading: false,
      title: SvgPicture.asset('아이콘 경로'),
      actions: [
        if (isActionButton)
          Padding(
            padding: EdgeInsets.only(right: StyleConstants.defaultPadding),
            child: SizedBox(
              height: 32.r,
              width: 32.r,
              child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onActionPressed,
                  icon: SvgPicture.asset(
                    IconPath.notifications,
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
