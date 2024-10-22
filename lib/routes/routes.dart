import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modakbul/screens/alert/alert_screen.dart';
import 'package:modakbul/screens/auth/auth_code_screen.dart';
import 'package:modakbul/screens/auth/auth_id_screen.dart';
import 'package:modakbul/screens/auth/auth_name_screen.dart';
import 'package:modakbul/screens/auth/auth_phone_screen.dart';
import 'package:modakbul/screens/auth/auth_profile_screen.dart';
import 'package:modakbul/screens/auth/terms_agreement_screen.dart';
import 'package:modakbul/screens/home/home_screen.dart';
import 'package:modakbul/screens/modakbul/create_content_screen.dart';
import 'package:modakbul/screens/modakbul/create_modakbul_screen.dart';
import 'package:modakbul/screens/modakbul/map_select_screen.dart';
import 'package:modakbul/screens/modakbul/modakbul_detail_screen.dart';
import 'package:modakbul/screens/search/add_friend_list_screen.dart';
import 'package:modakbul/screens/search/search_screen.dart';
import 'package:modakbul/screens/setting/alert_setting_screen.dart';
import 'package:modakbul/screens/setting/common_setting_screen.dart';
import 'package:modakbul/screens/setting/edit_my_profile_screen.dart';
import 'package:modakbul/screens/setting/friend_setting_screen.dart';
import 'package:modakbul/screens/setting/info_screen.dart';
import 'package:modakbul/screens/setting/my_profile_screen.dart';
import 'package:modakbul/screens/setting/terms_screen.dart';
import 'package:modakbul/screens/splash_screen.dart';
import 'package:modakbul/screens/start_screen.dart';


class Routes {
  Routes._();

  ///라우트 변수 선언 예시

  static const String alertScreen = '/alertScreen';

  static const String authCodeScreen = '/authCodeScreen';
  static const String authIdScreen = '/authIdScreen';
  static const String authNameScreen = '/authNameScreen';
  static const String authPhoneScreen = '/authPhoneScreen';
  static const String authProfileScreen = '/authProfileScreen';
  static const String termsAgreementScreen = '/termsAgreementScreen';

  static const String createGroupScreen = '/createGroupScreen';
  static const String friendScreen = '/friendScreen';

  static const String homeScreen = '/homeScreen';

  static const String createContentScreen = '/createContentScreen';
  static const String createModakbulScreen = '/createModakbulScreen';
  static const String mapSelectScreen = '/mapSelectScreen';
  static const String modakbulDetailScreen = '/modakbulDetailScreen';

  static const String addFriendListScreen = '/addFriendListScreen';
  static const String searchScreen = '/searchScreen';


  static const String alertSettingScreen = '/alertSettingScreen';
  static const String commonSettingScreen = '/commonSettingScreen';
  static const String editMyProfileScreen = '/editMyProfileScreen';
  static const String friendSettingScreen = '/friendSettingScreen';
  static const String infoScreen = '/infoScreen';
  static const String myProfileScreen = '/myProfileScreen';
  static const String termsScreen = '/termsScreen';

  static const String splashScreen = '/splashScreen';
  static const String startScreen = '/startScreen';

  ///라우트 추가 예시
  static final routes = <String, WidgetBuilder> {

    ///alert
    alertScreen: (BuildContext context) => const AlertScreen(),

    ///auth
    authCodeScreen: (BuildContext context) => const AuthCodeScreen(),
    authIdScreen: (BuildContext context) => const AuthIdScreen(),
    authNameScreen: (BuildContext context) => const AuthNameScreen(),
    authPhoneScreen: (BuildContext context) => const AuthPhoneScreen(),
    authProfileScreen: (BuildContext context) => const AuthProfileScreen(),
    termsAgreementScreen: (BuildContext context) => const TermsAgreementScreen(),

    ///home
    homeScreen: (BuildContext context) => const HomeScreen(),

    ///modakbul
    createContentScreen: (BuildContext context) => const CreateContentScreen(),
    createModakbulScreen: (BuildContext context) => const CreateModakbulScreen(),
    mapSelectScreen: (BuildContext context) => const MapSelectScreen(),
    modakbulDetailScreen: (BuildContext context) => const ModakbulDetailScreen(),

    ///search
    addFriendListScreen: (BuildContext context) => const AddFriendListScreen(),
    searchScreen: (BuildContext context) => const SearchScreen(),

    ///setting
    alertSettingScreen: (BuildContext context) => const AlertSettingScreen(),
    commonSettingScreen: (BuildContext context) => const CommonSettingScreen(),
    editMyProfileScreen: (BuildContext context) => const EditMyProfileScreen(),
    friendSettingScreen: (BuildContext context) => const FriendSettingScreen(),
    infoScreen: (BuildContext context) => const InfoScreen(),
    myProfileScreen: (BuildContext context) => const MyProfileScreen(),
    termsScreen: (BuildContext context) => const TermsScreen(),

    ///splash
    splashScreen: (BuildContext context) => const SplashScreen(),
    startScreen: (BuildContext context) => const StartScreen(),

  };
}