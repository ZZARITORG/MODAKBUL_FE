import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';

class BackButtonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isActionButton;
  final VoidCallback? onActionPressed;

  const BackButtonAppBar(
      {Key? key, this.isActionButton = false, this.onActionPressed})
      : super(key: key);

  factory BackButtonAppBar.actions({required VoidCallback onActionPressed}) =>
      BackButtonAppBar(
        isActionButton: true,
        onActionPressed: onActionPressed,
      );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false, ///스타일로 옮기기
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: EdgeInsets.only(left: StyleConstants.defaultPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
            children: [
          IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => Navigator.pop(context),
              icon: SvgPicture.asset(IconPath.arrowBack)),
        ]),
      ),
      actions: [
        if (isActionButton)
          Padding(
            padding: EdgeInsets.only(right: StyleConstants.defaultPadding),
            child: SizedBox(
              height: 24.h,
              width: 24.w,
              child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onActionPressed,
                  icon: SvgPicture.asset(IconPath.moreHorizontal)),
            ),
          ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
