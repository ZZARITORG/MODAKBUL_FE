import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/routes/routes.dart';
import 'package:modakbul/screens/alert/alert_screen.dart';
import 'package:modakbul/screens/auth/auth_id_screen.dart';
import 'package:modakbul/screens/auth/auth_phone_screen.dart';
import 'package:modakbul/screens/auth/terms_agreement_screen.dart';
import 'package:modakbul/screens/modakbul/modakbul_detail_screen.dart';
import 'package:modakbul/screens/modakbul/my_modakbul_screen.dart';
import 'package:modakbul/screens/modakbul/modakbul_map_detail_screen.dart';
import 'package:modakbul/screens/home/home_screen.dart';
import 'package:modakbul/screens/setting/alert_setting_screen.dart';
import 'package:modakbul/screens/setting/blocked_user_screen.dart';
import 'package:modakbul/screens/setting/common_setting_screen.dart';
import 'package:modakbul/screens/setting/edit_code_screen.dart';
import 'package:modakbul/screens/setting/edit_my_profile_screen.dart';
import 'package:modakbul/screens/setting/edit_phone_screen.dart';
import 'package:modakbul/screens/setting/friend_setting_screen.dart';
import 'package:modakbul/screens/setting/info_screen.dart';
import 'package:modakbul/screens/setting/my_profile_screen.dart';
import 'package:modakbul/screens/setting/terms_screen.dart';
import 'package:modakbul/widgets/custom_calender_picker.dart';
import 'package:modakbul/screens/modakbul/create_content_screen.dart';
import 'package:modakbul/screens/modakbul/create_modakbul_screen.dart';
import 'package:modakbul/screens/modakbul/group_select_screen.dart';
import 'package:modakbul/screens/splash_screen.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/home_screen_2_skeleton.dart';
import 'package:modakbul/widgets/home_screen_skeleton.dart';
import 'package:modakbul/widgets/fixed_modakbul_card.dart';
import 'package:modakbul/widgets/home_screen_skeleton.dart';
import 'package:modakbul/widgets/invited_modakbul_card.dart';
import 'package:modakbul/widgets/participate_bottom_sheet.dart'; // home_screen_skeleton 파일 import


void main() {
  runApp(
    ScreenUtilInit(
      designSize: const Size(393, 852), // 디자인 기준의 크기 (너비, 높이)
      minTextAdapt: true,
      builder: (context, child) {
        return MyApp(); // Your root widget
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routes: Routes.routes,
      theme: Styles.kThemeData,
      home: const HomeScreen2Skeleton(),
    );
  }
}
