import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isActionButton;
  final VoidCallback? onActionPressed;

  const LogoAppBar({Key? key, this.isActionButton = false, this.onActionPressed})
      : super(key: key);

  factory LogoAppBar.actions({required VoidCallback onActionPressed}) =>
      LogoAppBar(
        isActionButton: true,
        onActionPressed: onActionPressed,
      );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false, ///스타일 폴더로 옮기기
      automaticallyImplyLeading: false,
      title: SvgPicture.asset('아이콘 경로'),
      actions: [
        if (isActionButton)
          IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: onActionPressed,
              icon: SvgPicture.asset('아이콘 경로')),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
