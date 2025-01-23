import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/styles.dart';

import '../themes/color_schemes.dart';

class CustomTabBar extends StatelessWidget {
  final TabController tabController;
  final String leftTabTitle;
  final String rightTabTitle;

  //final GlobalKey _tabBarKey = GlobalKey();

  CustomTabBar({
    Key? key,
    required this.tabController,
    required this.leftTabTitle,
    required this.rightTabTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorSchemes.gray000,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: StyleConstants.defaultPadding),
        child: TabBar(
          controller: tabController,
          tabs: [
            SizedBox(
              height: 58.h,
              child: Tab(
                child: Text(
                  leftTabTitle,
                ),
              ),
            ),
            SizedBox(
              height: 58.h,
              child: Tab(
                child: Text(
                  rightTabTitle,
                ),
              ),
            ),
          ],
          dividerColor: Colors.transparent,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicator:
          CircleTabIndicator(color: ColorSchemes.orange200, radius: 2.r),
          overlayColor: const WidgetStatePropertyAll(
            ColorSchemes.orange100,
          ),
          labelPadding: EdgeInsets.only(bottom: 4.h, right: 18.h),
          labelColor: ColorSchemes.orange200,
          unselectedLabelColor: ColorSchemes.gray200,
          labelStyle: Theme.of(context).textTheme.bigHeadLine3.copyWith(
              fontFamily: 'PretendardVariable', color: ColorSchemes.orange200),
          unselectedLabelStyle: Theme.of(context).textTheme.bigHeadLine3.copyWith(
              fontFamily: 'PretendardVariable', color: ColorSchemes.gray200),
          indicatorColor: ColorSchemes.orange200,
          indicatorSize: TabBarIndicatorSize.label,
        ),
      ),
    );
  }
}

class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({
    required Color color,
    required double radius,
  }) : _painter = _CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
    ..color = color
    ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset =
        offset + Offset(cfg.size!.width / 2, cfg.size!.height - radius - 12.h);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}
