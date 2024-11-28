import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/custom_button.dart';
import 'package:modakbul/widgets/invited_modakbul_card.dart';

class BrowseTabScreen extends StatefulWidget {
  const BrowseTabScreen({super.key});

  @override
  State<BrowseTabScreen> createState() => _State();
}

class _State extends State<BrowseTabScreen> {
  final List<Map<String, dynamic>> invitedModakbulData = [
    {
      'profileLength': 3,
      'userName': '김지호',
      'userId': 'kim_jj0_',
      'title': '편의점에서 간단하게 맥주 한 잔 할 사람?',
      'description':
          '지금 바로 우리집 앞에 편의점에서 맥주 먹을 사람 구합니다. 두줄까지 카드형식으로 나오고 어쩌고저쩌고 그랬다가 저랬다가',
      'date': '10.2(화) 오후 8시',
      'location': '렁지랕지',
    },
    {
      'profileLength': 3,
      'userName': '김지호',
      'userId': 'kim_jj0_',
      'title': '편의점에서 간단하게 맥주 한 잔 할 사람?',
      'description':
          '지금 바로 우리집 앞에 편의점에서 맥주 먹을 사람 구합니다. 두줄까지 카드형식으로 나오고 어쩌고저쩌고 그랬다가 저랬다가',
      'date': '10.2(화) 오후 8시',
      'location': '렁지랕지',
    },
    {
      'profileLength': 3,
      'userName': '김지호',
      'userId': 'kim_jj0_',
      'title': '편의점에서 간단하게 맥주 한 잔 할 사람?',
      'description':
          '지금 바로 우리집 앞에 편의점에서 맥주 먹을 사람 구합니다. 두줄까지 카드형식으로 나오고 어쩌고저쩌고 그랬다가 저랬다가',
      'date': '10.2(화) 오후 8시',
      'location': '렁지랕지',
    },
    {
      'profileLength': 3,
      'userName': '김지호',
      'userId': 'kim_jj0_',
      'title': '편의점에서 간단하게 맥주 한 잔 할 사람?',
      'description':
          '지금 바로 우리집 앞에 편의점에서 맥주 먹을 사람 구합니다. 두줄까지 카드형식으로 나오고 어쩌고저쩌고 그랬다가 저랬다가',
      'date': '10.2(화) 오후 8시',
      'location': '렁지랕지',
    },
    {
      'profileLength': 3,
      'userName': '김지호',
      'userId': 'kim_jj0_',
      'title': '편의점에서 간단하게 맥주 한 잔 할 사람?',
      'description':
          '지금 바로 우리집 앞에 편의점에서 맥주 먹을 사람 구합니다. 두줄까지 카드형식으로 나오고 어쩌고저쩌고 그랬다가 저랬다가',
      'date': '10.2(화) 오후 8시',
      'location': '렁지랕지',
    },
  ];

  final List<String> filters = ['전체', '최신순', '오늘', '마감 임박'];
  String selectedFilter = '전체';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 14.h,),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(StyleConstants.radiusMedium),
                  color: ColorSchemes.white,
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 10,
                        color: Color(0x40F3F3F3))
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('혼자는 너무 춥지 않아?',
                          style: Theme.of(context)
                              .textTheme
                              .bigHeadLine4
                              .copyWith(color: ColorSchemes.orange200)),
                      SizedBox(
                        height: 6.h,
                      ),
                      Row(
                        children: [
                          Text('모닥불 피우러가기',
                              style: Theme.of(context)
                                  .textTheme
                                  .body2
                                  .copyWith(color: ColorSchemes.orange100)),
                          SizedBox(
                            width: 6.w,
                          ),
                          SvgPicture.asset(IconPath.arrowForward15Orange100),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 75.w,
                    height: 75.h,
                    child: Image.asset(ImagePath.homeModakbul),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 24.h,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                      children: filters.map((filter) {
                    final isSelected = selectedFilter == filter;
                    return Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedFilter = filter;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected
                              ? ColorSchemes.orange200
                              : ColorSchemes.orange000,
                          padding: EdgeInsets.symmetric(
                              vertical: 7.h, horizontal: 14.w),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  StyleConstants.radiusMedium)),
                        ),
                        child: Row(
                          children: [
                            Text(
                              filter,
                              style: Theme.of(context).textTheme.body3.copyWith(
                                    color: isSelected
                                        ? ColorSchemes.white
                                        : ColorSchemes.orange100,
                                  ),
                            ),
                            if (filter == '전체')
                              SizedBox(
                                  width: 18.w,
                                  height: 18.h,
                                  child: Image.asset(
                                    ImagePath.browseSmallModakbul,
                                  )),
                          ],
                        ),
                      ),
                    );
                  }).toList()),
                  SizedBox(
                    height: 12.h,
                  ),
                  ListView.builder(
                    itemCount: invitedModakbulData.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final data = invitedModakbulData[index];
                      return Padding(
                        padding: index != invitedModakbulData.length - 1
                            ? EdgeInsets.only(bottom: 12.h)
                            : EdgeInsets.only(bottom: 0.h),
                        child: InvitedModakbulCard(
                            profileLength: data['profileLength'],
                            userName: data['userName'],
                            userId: data['userId'],
                            title: data['title'],
                            description: data['description'],
                            date: data['date'],
                            location: data['location']),
                      );
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
