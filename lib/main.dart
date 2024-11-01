import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/routes/routes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/invited_modakbul_card.dart';

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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            // InvitedModakbulCard를 추가
            InvitedModakbulCard(
              profileImage1: 'https://example.com/profile.jpg', // 프로필 이미지 URL 또는 리스트
              profileLength: 2,
              userName: '김지호',
              userId: 'kim_jjO',
              title: '편의점에서 간단하게 맥주 먹을 사람!',
              description: '모임 설명',
              date: '10.1(화) 오후 7시',
              location: 'GS25 세운푸르지오점',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}