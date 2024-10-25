import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String appBarType;
  final VoidCallback? onActionPressed;

  const LogoAppBar({Key? key, this.appBarType = 'basic', this.onActionPressed})
      : super(key: key);

  factory LogoAppBar.actions({required VoidCallback onActionPressed}) =>
      LogoAppBar(
        appBarType: 'action',
        onActionPressed: onActionPressed,
      );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: SvgPicture.asset('아이콘 경로'),
      actions: [
        if (appBarType == 'action')
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
