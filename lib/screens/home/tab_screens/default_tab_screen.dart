import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/fixed_modakbul_card.dart';
import 'package:modakbul/widgets/invited_modakbul_card.dart';
import 'package:modakbul/widgets/my_modakbul_card.dart';

class DefaultTabScreen extends StatefulWidget {
  const DefaultTabScreen({super.key});

  @override
  State<DefaultTabScreen> createState() => _State();
}

class _State extends State<DefaultTabScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: ColorSchemes.white,
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, 4),
                      blurRadius: 10,
                      color: Color(0x40F3F3F3))
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('혼자는 너무 춥지 않아?',
                        style: Theme.of(context)
                            .textTheme
                            .bigHeadLine4
                            .copyWith(color: ColorSchemes.orange200)),
                    SizedBox(
                      height: 6.h,
                    ),
                    Row(
                      children: [
                        Text('모닥불 피우러가기',
                            style: Theme.of(context)
                                .textTheme
                                .body2
                                .copyWith(color: ColorSchemes.orange100)),
                        SizedBox(
                          width: 6.w,
                        ),
                        SvgPicture.asset(IconPath.arrowForward15Orange100),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: 75.w,
                  height: 75.h,
                )
              ],
            ),
          ),
          SizedBox(
            height: 14.h,
          ),
          const MyModakbulCard(
              profileLength: 3,
              userName: 'userName',
              userId: 'userId',
              title: 'title',
              description: 'description',
              date: 'date',
              location: 'location'),
          SizedBox(
            height: 24.h,
          ),
          Text(
            '약속된 모닥불',
              style: Theme.of(context)
                  .textTheme
                  .bigHeadLine4
                  .copyWith(color: ColorSchemes.gray500)
          ),
          SizedBox(height: 14.h,),
          //singlechildview로
          const FixedModakbulCard(title: 'title', date: 'date', location: 'location'),

        ],
      ),
    );
  }
}
