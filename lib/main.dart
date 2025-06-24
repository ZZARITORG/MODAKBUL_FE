import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:modakbul/constants/api_path.dart';
import 'package:modakbul/providers/auth_provider.dart';
import 'package:modakbul/providers/friend_provider.dart';
import 'package:modakbul/providers/location_provider.dart';
import 'package:modakbul/providers/meeting_provider.dart';
import 'package:modakbul/providers/place_provider.dart';
import 'package:modakbul/routes/routes.dart';
import 'package:modakbul/screens/splash_screen.dart';
import 'package:modakbul/services/firebase_messaging_service.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/utils/global_variable.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

late SharedPreferences prefs;

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage msg) =>
    FirebaseMessagingService.firebaseMessagingBackgroundHandler(msg);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 백그라운드 메시지 핸들러 등록
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  // 로컬 노티 설정 & 토큰
  await FirebaseMessagingService().setupFlutterNotifications();
  FirebaseMessagingService().getToken();

  await dotenv.load();
  AuthRepository.initialize(appKey: ApiPath.appKey);

  runApp(
    ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      builder: (_, __) => const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // 클릭 핸들러 등록
    FirebaseMessagingService().initialize();
    // foreground 데이터-only 처리
    FirebaseMessagingService().registerForegroundHandler();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PlaceProvider()),
        ChangeNotifierProvider(create: (_) => MeetingProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => FriendProvider()),
      ],
      child: MaterialApp(
        navigatorKey: GlobalVariable.navState,
        debugShowCheckedModeBanner: false,
        title: '모닥불',
        theme: Styles.kThemeData,
        routes: Routes.routes,
        home: const SplashScreen(),
      ),
    );
  }
}