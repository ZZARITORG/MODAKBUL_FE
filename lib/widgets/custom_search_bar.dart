import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modakbul/main.dart';
import 'package:modakbul/themes/styles.dart';

import '../themes/color_schemes.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;

  const CustomSearchBar({Key? key, required this.hintText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
          style: Theme.of(context).textTheme.body1.copyWith(color: ColorSchemes.gray500),
          cursorColor: Theme.of(context).primaryColorLight, //바뀔 수도 있음
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 14, right: 4),
              child: SizedBox(
                height: 24,
                width: 24,
                child: SvgPicture.asset(
                  '아이콘 경로',
                  fit: BoxFit.none,
                ),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 24,
              minHeight: 24,
            ),
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.body1.copyWith(color: ColorSchemes.gray200),
            isDense: true,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(14)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(14)),
            filled: true,
            fillColor: ColorSchemes.gray100,
            ///suffixIcon: 추후 x아이콘
          )),
    );
  }
}
