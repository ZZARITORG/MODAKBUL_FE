import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/log_out_dialog.dart';
import 'package:modakbul/widgets/setting_menu.dart';
import 'package:modakbul/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:modakbul/widgets/delete_user_bottom_sheet.dart';


class TermsScreen extends StatelessWidget {
  TermsScreen({super.key});

  UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSchemes.gray000,
      appBar: BackButtonAppBar(backgroundColor: ColorSchemes.gray000),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 26.h),
            Text(
              '이용약관',
              style: Theme.of(context)
                  .textTheme
                  .smallHeadLine3
                  .copyWith(color: ColorSchemes.orange200),
            ),
            SizedBox(height: 28.h),
            SettingMenu.arrow(
                menu: '이용약관',
                icon: IconPath.description,
                iconWidth: 16.r,
                onPressed: () {}),
            SizedBox(height: 28.h),
            SettingMenu.arrow(
                menu: '개인정보 처리 방침',
                icon: IconPath.description,
                iconWidth: 16.r,
                onPressed: () {}),
            SizedBox(height: 28.h),
        InkWell(
          overlayColor: WidgetStateProperty.all(ColorSchemes.orange000),
          onTap: () async{
            await showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (BuildContext context) => SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: DeleteUserBottomSheet(),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: ColorSchemes.gray100, width: 1.w),
                )),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                          width: 24.r,
                          height: 24.r,
                          child: Center(
                              child: SvgPicture.asset(IconPath.blockGray200,
                                  width: 16.r, ))),
                      SizedBox(width: 2.w),
                      Text('탈퇴하기',
                          style: Theme.of(context)
                              .textTheme
                              .body2
                              .copyWith(color: ColorSchemes.gray200)),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 2.w),
                    child: SvgPicture.asset(
                      IconPath.arrowForward15Gray200,
                      width: 8.r,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
          ],
        ),
      ),
    );
  }
}
