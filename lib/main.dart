import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/providers/auth_provider.dart';
import 'package:modakbul/routes/routes.dart';
import 'package:modakbul/screens/main_screen.dart';
import 'package:modakbul/screens/splash_screen.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart'; // home_screen_skeleton 파일 import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load();
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
        ChangeNotifierProvider(create: (_) => AuthProvider())
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
