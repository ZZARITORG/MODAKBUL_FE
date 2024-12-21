import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:modakbul/providers/auth_provider.dart';
import 'package:modakbul/providers/meeting_provider.dart';
import 'package:modakbul/providers/place_provider.dart';
import 'package:modakbul/routes/routes.dart';
import 'package:modakbul/screens/auth/auth_profile_screen.dart';
import 'package:modakbul/screens/home/home_screen.dart';
import 'package:modakbul/screens/main_screen.dart';
import 'package:modakbul/screens/splash_screen.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/utils/location_manager.dart';
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
  await dotenv.load();
  AuthRepository.initialize(appKey: dotenv.env['KAKAO_REST_JAVASCRIPT_KEY'] ?? '');
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PlaceProvider()),
        ChangeNotifierProvider(create: (_) => MeetingProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        routes: Routes.routes,
        theme: Styles.kThemeData,
        home: const SplashScreen(),
      ),
    );
  }
}
