import 'package:flutter/material.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/themes/color_schemes.dart';

class GlobalErrorWidget extends StatelessWidget {
  const GlobalErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '오류가 발생했습니다.',
            style: Theme.of(context)
                .textTheme
                .bigHeadLine3
                .copyWith(color: ColorSchemes.orange100),
          ),
          const SizedBox(height: 8),
          Text(
            '잠시 후 이용해주세요.',
            style: Theme.of(context)
                .textTheme
                .body2
                .copyWith(color: ColorSchemes.gray300),
          ),
        ],
      ),
    );
  }
}