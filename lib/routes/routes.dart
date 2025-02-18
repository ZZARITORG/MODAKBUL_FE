import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modakbul/screens/alert/alert_screen.dart';
import 'package:modakbul/screens/auth/auth_code_screen.dart';
import 'package:modakbul/screens/auth/auth_id_screen.dart';
import 'package:modakbul/screens/auth/auth_name_screen.dart';
import 'package:modakbul/screens/auth/auth_phone_screen.dart';
import 'package:modakbul/screens/auth/auth_profile_screen.dart';
import 'package:modakbul/screens/auth/image_cropper_screen.dart';
import 'package:modakbul/screens/auth/terms_agreement_screen.dart';
import 'package:modakbul/screens/home/home_screen.dart';
import 'package:modakbul/screens/main_screen.dart';
import 'package:modakbul/screens/modakbul/create_content_screen.dart';
import 'package:modakbul/screens/modakbul/create_modakbul_screen.dart';
import 'package:modakbul/screens/modakbul/group_select_screen.dart';
import 'package:modakbul/screens/modakbul/map_search_screen.dart';
import 'package:modakbul/screens/modakbul/map_select_screen.dart';
import 'package:modakbul/screens/modakbul/modakbul_detail_screen.dart';
import 'package:modakbul/screens/modakbul/modakbul_map_detail_screen.dart';
import 'package:modakbul/screens/modakbul/my_modakbul_screen.dart';
import 'package:modakbul/screens/friend/add_friend_screen.dart';
import 'package:modakbul/screens/search/search_screen.dart';
import 'package:modakbul/screens/setting/alert_setting_screen.dart';
import 'package:modakbul/screens/setting/blocked_user_screen.dart';
import 'package:modakbul/screens/setting/change_number_code_screen.dart';
import 'package:modakbul/screens/setting/change_number_screen.dart';
import 'package:modakbul/screens/setting/common_setting_screen.dart';
import 'package:modakbul/screens/setting/edit_my_profile_screen.dart';
import 'package:modakbul/screens/setting/friend_setting_screen.dart';
import 'package:modakbul/screens/setting/info_screen.dart';
import 'package:modakbul/screens/setting/my_profile_screen.dart';
import 'package:modakbul/screens/setting/terms_screen.dart';
import 'package:modakbul/screens/splash_screen.dart';
import 'package:modakbul/screens/setting/image_cropper_setting_screen.dart';


class Routes {
  Routes._();

  ///라우트 변수 선언 예시
  static const String alertScreen = '/alertScreen';
  static const String authCodeScreen = '/authCodeScreen';
  static const String authIdScreen = '/authIdScreen';
  static const String authNameScreen = '/authNameScreen';
  static const String authPhoneScreen = '/authPhoneScreen';
  static const String authProfileScreen = '/authProfileScreen';
  static const String imageCropperScreen = '/imageCropperScreen';
  static const String termsAgreementScreen = '/termsAgreementScreen';
  static const String homeScreen = '/homeScreen';
  static const String createContentScreen = '/createContentScreen';
  static const String createModakbulScreen = '/createModakbulScreen';
  static const String groupSelectScreen = '/groupSelectScreen';
  static const String mapSearchScreen = '/mapSearchScreen';
  static const String mapSelectScreen = '/mapSelectScreen';
  static const String modakbulDetailScreen = '/modakbulDetailScreen';
  static const String addFriendScreen = '/addFriendScreen';
  static const String searchScreen = '/searchScreen';
  static const String alertSettingScreen = '/alertSettingScreen';
  static const String blockedUserScreen = '/blockedUserScreen';
  static const String commonSettingScreen = '/commonSettingScreen';
  static const String editCodeScreen = '/editCodeScreen';
  static const String editMyProfileScreen = '/editMyProfileScreen';
  static const String friendSettingScreen = '/friendSettingScreen';
  static const String imageCropperSettingScreen = '/imageCropperSettingScreen';
  static const String infoScreen = '/infoScreen';
  static const String myProfileScreen = '/myProfileScreen';
  static const String termsScreen = '/termsScreen';
  static const String splashScreen = '/splashScreen';
  static const String mainScreen = '/mainScreen';
  static const String changeNumberScreen = '/changeNumberScreen';
  static const String changeNumberCodeScreen = '/changeNumberCodeScreen';
  static const String myModakbulScreen = '/myModakbulScreen';
  static const String modakbulMapDetailScreen = '/modakbulMapDetailScreen';

  ///라우트 추가 예시
  static final Map<String, WidgetBuilder> routes = {
    ///alert
    alertScreen: (BuildContext context) => const AlertScreen(),

    ///auth
    authCodeScreen: (BuildContext context) => const AuthCodeScreen(),
    authIdScreen: (BuildContext context) => const AuthIdScreen(),
    authNameScreen: (BuildContext context) => const AuthNameScreen(),
    authPhoneScreen: (BuildContext context) => const AuthPhoneScreen(),
    authProfileScreen: (BuildContext context) => const AuthProfileScreen(),
    imageCropperScreen: (BuildContext context) => const ImageCropperScreen(),
    termsAgreementScreen: (BuildContext context) => const TermsAgreementScreen(),

    ///home
    homeScreen: (BuildContext context) => const HomeScreen(),

    ///modakbul
    createContentScreen: (BuildContext context) => const CreateContentScreen(),
    createModakbulScreen: (BuildContext context) => const CreateModakbulScreen(),
    groupSelectScreen: (BuildContext context) => const GroupSelectScreen(),
    mapSearchScreen: (BuildContext context) => const MapSearchScreen(),
    mapSelectScreen: (BuildContext context) => MapSelectScreen(),
    modakbulDetailScreen: (BuildContext context) => const ModakbulDetailScreen(),
    myModakbulScreen: (BuildContext context) => const MyModakbulScreen(),
    modakbulMapDetailScreen: (BuildContext context) => const ModakbulMapDetailScreen(),

    ///search
    addFriendScreen: (BuildContext context) => const AddFriendScreen(),
    searchScreen: (BuildContext context) => const SearchScreen(),

    ///setting
    alertSettingScreen: (BuildContext context) => const AlertSettingScreen(),
    blockedUserScreen: (BuildContext context) => BlockedUserScreen(),
    changeNumberCodeScreen: (BuildContext context) => const ChangeNumberCodeScreen(),
    changeNumberScreen: (BuildContext context) => const ChangeNumberScreen(),
    commonSettingScreen: (BuildContext context) => const CommonSettingScreen(),
    editMyProfileScreen: (BuildContext context) => EditMyProfileScreen(),
    friendSettingScreen: (BuildContext context) => const FriendSettingScreen(),
    imageCropperSettingScreen: (BuildContext context) => const ImageCropperSettingScreen(),
    infoScreen: (BuildContext context) => const InfoScreen(),
    myProfileScreen: (BuildContext context) => MyProfileScreen(),
    termsScreen: (BuildContext context) => TermsScreen(),

    ///splash
    splashScreen: (BuildContext context) => const SplashScreen(),
    mainScreen: (BuildContext context) => const MainScreen(),
  };

  /// FadeTransition을 사용하는 커스텀 페이지 빌더
  static Route _fadePage(Widget page, Object? arguments) {
    return CupertinoPageRoute(
      builder: (context) => page,
      settings: RouteSettings(arguments: arguments),
    );
  }

  static Future<void> navigateTo(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.push(
      context,
      _fadePage(routes[routeName]!(context), arguments),
    );
  }

  static Future<void> navigateAndRemoveUntil(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushAndRemoveUntil(
      context,
      _fadePage(routes[routeName]!(context), arguments), // Arguments 전달
          (route) => false, // 모든 이전 페이지를 제거
    );
  }

  static Future<void> navigateAndRemoveUntilFirst(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushAndRemoveUntil(
      context,
      _fadePage(routes[routeName]!(context), arguments), // Arguments 전달
          (route) => route.isFirst, // 모든 이전 페이지를 제거
    );
  }

  static Future<void> navigateReplacement(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushReplacement(
      context,
      _fadePage(routes[routeName]!(context), arguments),
    );
  }

  static PageRouteBuilder _fadePageSplash(Widget page, Object? arguments) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: page,
        );
      },
      transitionDuration: const Duration(milliseconds: 1200),
      settings: RouteSettings(arguments: arguments),
    );
  }

  static Future<void> navigateSplashReplacement(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushReplacement(
      context,
      _fadePageSplash(routes[routeName]!(context), arguments),
    );
  }

  static Future<dynamic> navigateAndReturn(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.push(
      context,
      _fadePage(routes[routeName]!(context), arguments),
    );
  }
}

