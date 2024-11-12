import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/routes/routes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/home_screen_skeleton.dart'; // home_screen_skeleton 파일 import

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
      title: 'Flutter Demo',
      routes: Routes.routes,
      theme: Styles.kThemeData,
      home: const MyHomePage(title: '테스트'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.bigHeadLine2,
        ),
      ),
      body: const HomeScreenSkeleton(), // home_screen_skeleton으로 변경
    );
  }
}