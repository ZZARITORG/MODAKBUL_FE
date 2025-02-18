import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/services/user_service.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/custom_button.dart';

import 'package:modakbul/providers/auth_provider.dart' as modakbul_auth_provider;

import 'log_out_dialog.dart';


class DeleteUserBottomSheet extends StatelessWidget {
  DeleteUserBottomSheet({Key? key}) : super(key: key);

  UserService userService = UserService();
  late modakbul_auth_provider.AuthProvider authProvider;

  void _handleDeleteUser(BuildContext context) async {
    try {

      final firebaseUser = FirebaseAuth.instance.currentUser;
      final firebaseUid = firebaseUser!.uid;

      await userService.deleteUser(firebaseUid);

      final storage = FlutterSecureStorage();
      await storage.deleteAll();

      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (BuildContext context) => LogOutDialog(),
          barrierDismissible: false,
        );
      }

    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('탈퇴에 실패했습니다: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(StyleConstants.radiusLarge),
              topRight: Radius.circular(StyleConstants.radiusLarge),
            ),
            color: ColorSchemes.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 38.h,
            ),
            Text(
              '정말 탈퇴 하시겠습니까?',
              style: Theme.of(context)
                  .textTheme
                  .bigHeadLine3
                  .copyWith(color: ColorSchemes.orange200, height: 1.193, decoration: TextDecoration.none),
            ),
            SizedBox(
              height: 12.h,
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                '탈퇴가 진행되면 기존의 데이터가 삭제되며 복구할 수 없습니다.',
                style: Theme.of(context)
                    .textTheme
                    .body2
                    .copyWith(color: ColorSchemes.gray300, height: 1.625, decoration: TextDecoration.none),
              ),
            ),
            SizedBox(
              height: 29.h,
            ),
            SizedBox(
                width: double.infinity,
                height: 56.h,
                child: CustomButton(
                    text: '탈퇴하기',
                    onPressed: () => _handleDeleteUser(context),
                    buttonColor: ColorSchemes.orange200,
                    textStyle: Theme.of(context).textTheme.smallHeadLine2,
                    textColor: ColorSchemes.white))
          ],
        ),
      ),
    );
  }
}

