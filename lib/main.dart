import 'package:firebase_core/firebase_core.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessagingService().setupFlutterNotifications();
  // FirebaseMessagingService().initialize;
  await dotenv.load();
  AuthRepository.initialize(appKey: ApiPath.appKey);
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FirebaseMessagingService().initialize();
    // foreground 수신처리
    // FirebaseMessaging.onMessage.listen(FirebaseMessagingService().showFlutterNotification);
    // background 수신처리
    // FirebaseMessaging.onBackgroundMessage(FirebaseMessagingService().firebaseMessagingBackgroundHandler);
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
        title: 'Flutter Demo',
        routes: Routes.routes,
        theme: Styles.kThemeData,
        home: const SplashScreen(),
      ),
    );
  }
}
