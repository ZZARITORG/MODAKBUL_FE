import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modakbul/screens/friend/tab_screens/custom_friends_tab_screen.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/select_user_list_profile.dart';
import 'package:modakbul/widgets/tab_bar_delegate.dart';
import '../../constants/assets_path.dart';
import '../../constants/style_constants.dart';

class GroupEditScreen extends StatefulWidget {
  const GroupEditScreen({super.key});

  @override
  State<GroupEditScreen> createState() => _GroupEditScreenState();
}

///TODO SingleTickerProviderStateMixin 공부
class _GroupEditScreenState extends State<GroupEditScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      // 탭이 변경될 때 스크롤 위치 초기화
      if (_tabController.indexIsChanging) {
        // FriendsTabScreen과 GroupsTabScreen에서 각각 ScrollController를 관리하고
        // 여기서 해당 controller의 animateTo를 호출
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSchemes.gray000,
      appBar: BackButtonAppBar.actions(
        backgroundColor: ColorSchemes.gray000,
        onActionPressed: () {},
      ),
      body: Column(
        children: [
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
            child: TextField(
                style: Theme.of(context)
                    .textTheme
                    .body1
                    .copyWith(color: ColorSchemes.gray500),
                cursorColor: ColorSchemes.orange100,
                //바뀔 수도 있음
                onTapOutside: (event) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  counterText: '',
                  suffixIcon: SizedBox(
                    height: 32.r,
                    width: 32.r,
                    child: IconButton(
                      padding: EdgeInsets.only(right: 2.w),
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        IconPath.edit,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                  suffixIconConstraints: BoxConstraints(
                    minWidth: 0.w,
                    minHeight: 0.h,
                  ),
                  hintText: '가볍게 커피챗하는 모임',
                  hintStyle: Theme.of(context)
                      .textTheme
                      .smallHeadLine1
                      .copyWith(color: ColorSchemes.gray200),
                  isDense: true,
                  contentPadding:
                  EdgeInsets.only(left: 4.w, bottom: 4.h),
                  border: InputBorder.none,
                  errorText: null,
                  errorStyle: const TextStyle(
                      color: ColorSchemes.orange100, fontSize: 0),
                  ///suffixIcon: 추후 x아이콘
                )),
          ),
          const Expanded(
            child: CustomFriendsTabScreen(),
          )
        ],
      ),
    );
  }
}
