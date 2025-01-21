import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';

class LogoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isActionButton;
  final VoidCallback? onActionPressed;
  final Color? backgroundColor;
  final bool hasNotification;

  const LogoAppBar(
      {Key? key,
      this.backgroundColor,
      this.isActionButton = false,
      this.onActionPressed,
      this.hasNotification = false})
      : super(key: key);

  factory LogoAppBar.actions(
          {required VoidCallback onActionPressed,
          Color? backgroundColor,
          hasNotification}) =>
      LogoAppBar(
          isActionButton: true,
          onActionPressed: onActionPressed,
          backgroundColor: backgroundColor,
          hasNotification: hasNotification);

  @override
  Widget build(BuildContext context) {
    Logger().i('지금 앱바에 넘어온게 $hasNotification');
    return AppBar(
      centerTitle: false,
      backgroundColor: backgroundColor,

      ///스타일 폴더로 옮기기
      automaticallyImplyLeading: false,
      title: SvgPicture.asset(
        IconPath.modakbulLogo,
        width: 79.w,
      ),
      actions: [
        if (isActionButton)
          Padding(
            padding: EdgeInsets.only(right: StyleConstants.defaultPadding),
            child: Stack(clipBehavior: Clip.none, children: [
              SizedBox(
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
              hasNotification
                  ? Positioned(
                      top: 4.r,
                      right: 4.r,
                      child: SvgPicture.asset(
                          width: 5.r, height: 5.r, IconPath.notificationDot))
                  : const SizedBox.shrink()
            ]),
          ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight.h);
}
