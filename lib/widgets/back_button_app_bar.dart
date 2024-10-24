import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BackButtonAppBar extends StatelessWidget {
  final String appBarType;

  const BackButtonAppBar({Key? key, this.appBarType = 'basic'}) : super(key: key);

  factory BackButtonAppBar.actions() => const BackButtonAppBar(
    appBarType: 'action',
  );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: (){},
          icon: SvgPicture.asset('아이콘 경로')),
      actions: [
        if (appBarType == 'action')
          IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: (){},
              icon: SvgPicture.asset('아이콘 경로')),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

