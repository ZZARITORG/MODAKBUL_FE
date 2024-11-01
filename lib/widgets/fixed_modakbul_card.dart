import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/styles.dart';
import '../themes/color_schemes.dart';

class FixedModakbulCard extends StatelessWidget {
  final String title;
  final String date;
  final String location;
  
  const FixedModakbulCard({
    Key? key,
    required this.title,
    required this.date,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 24.h, 21.w, 18.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 250.w,
              height: 48.h,
              child: Text(
                title,

                  style: Theme.of(context)
                      .textTheme.bigHeadLine4
                      .copyWith(color: ColorSchemes.gray400)
              ),


            ),
            SizedBox(height: 14.h),
            Row(
             children: [
               SizedBox(
                 width: 20.w,
                 height: 20.h,
                 child: SvgPicture.asset(
                   'assets/icons/Group 3336.svg'
                 ),
               ),
               SizedBox(
                 width: 4.w,
               ),
               Text(
                 date,
                   style: Theme.of(context)
                       .textTheme.body3
                       .copyWith(color: ColorSchemes.orange001)
               )
             ],
            ),
            SizedBox(
                height: 6.h
            ),
            Row(
              children: [
                SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: SvgPicture.asset(
                      'assets/icons/Subtract.svg'
                  ),
                ),
                SizedBox(
                  width: 4.w,
                ),
                Text(
                    location,
                    style: Theme.of(context)
                        .textTheme.body3
                        .copyWith(color: ColorSchemes.orange001)
                )
              ],
            ),

          ],
        ),
      ),
    );
  }
}
