import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/my_modakbul_list_tile.dart';

class MyModakbulScreen extends StatefulWidget {
  const MyModakbulScreen({super.key});

  @override
  State<MyModakbulScreen> createState() => _MyModakbulScreenState();
}

class _MyModakbulScreenState extends State<MyModakbulScreen> {
  final List<Map<String, dynamic>> modakbuls = [
    {
      'title': '서현 모임',
      'time': '2024.11.1 (월)',
      'length': 3,
    },
    {
      'title': '동국대 충무로 모임',
      'time': '2024.11.1 (금)',
      'length': 2,
    },
    {
      'title': '이매고 모임',
      'time': '2024.11.1 (목)',
      'length': 6,
    },
    {
      'title': '콩팥에 인생 바친 모임',
      'time': '2024.1.1 (일)',
      'length': 1,
    },
    {
      'title': '모각코 모임',
      'time': '2024.4.23 (화)',
      'length': 0,
    },
    {
      'title': '짜릿한 모임',
      'time': '2024.12.1 (월)',
      'length': 3,
    },
  ];

  void _toggleSelectedCard(int index) {
    setState(() {
      modakbuls[index]['isSelected'] = !modakbuls[index]['isSelected'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BackButtonAppBar.actions(
            onActionPressed: () {}, backgroundColor: ColorSchemes.gray000),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),

          ///데이터의 양이 많지 않고 단순한 하나의 스크롤이라 NestedScrollView 사용 안함
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 24.h,
                ),
                SizedBox(
                  width: 205.w,
                  child: Text('약속된 모닥불이\n2개 있습니다',
                      style: Theme.of(context)
                          .textTheme
                          .bigHeadLine2
                          .copyWith(color: ColorSchemes.gray500)),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text('그룹을 선택하면 자동으로 알림이 전송됩니다.',
                    style: Theme.of(context)
                        .textTheme
                        .body2
                        .copyWith(color: ColorSchemes.gray400)),
                SizedBox(
                  height: 24.h,
                ),
                ...modakbuls.map((modakbul) {
                  int index = modakbuls.indexOf(modakbul);
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () => _toggleSelectedCard(index),
                        child: MyModakbulListTile(
                            title: modakbul['title'],
                            time: modakbul['time'],
                            profileLength: modakbul['length'],
                            isSelected: modakbul['isSelected']),
                      ),
                      if (index != modakbuls.length - 1) SizedBox(height: 16.h),
                    ],
                  );
                })
              ],
            ),
          ),
        ));
  }
}
