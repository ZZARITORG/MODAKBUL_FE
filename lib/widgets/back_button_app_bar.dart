import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BackButtonAppBar extends StatelessWidget {
  final bool isActionButton;
  final VoidCallback? onActionPressed;

  const BackButtonAppBar({Key? key, this.isActionButton = false, this.onActionPressed}) : super(key: key);

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
      leading: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset('아이콘 경로')),
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

