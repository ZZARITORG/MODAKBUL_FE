import 'package:flutter/material.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/main.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';

class AlertListTile extends StatelessWidget {
  final String title;
  final String content;
  final String iconName;
  final String time;

  const AlertListTile(
      {Key? key,
      required this.title,
      required this.content,
      required this.iconName,
      required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 18, 12, 9),
      decoration: BoxDecoration(
          color: ColorSchemes.white,
          borderRadius: BorderRadius.circular(StyleConstants.radiusMedium)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: StyleConstants.circleSizeM,
            backgroundColor: ColorSchemes.gray100,

            ///이미지 영역
          ),
          const SizedBox(
            width: 6,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .bigHeadLine5
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(content,
                  style: Theme.of(context)
                  .textTheme
                  .body2
                  .copyWith(color: ColorSchemes.gray400),),
              const SizedBox(
                height: 8,
              ),
              Text(time,
                style: Theme.of(context)
                    .textTheme
                    .body3
                    .copyWith(color: ColorSchemes.gray200),),
            ],
          )
        ],
      ),
    );
  }
}
