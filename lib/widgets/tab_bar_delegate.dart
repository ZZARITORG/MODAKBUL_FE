import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_tab_bar.dart';

class TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  final String leftTabTitle;
  final String rightTabTitle;
  final double maxHeight;
  final double minHeight;
  final bool isRebuild;

  TabBarDelegate({
    required this.tabController,
    required this.leftTabTitle,
    required this.rightTabTitle,
    required double maxHeight,
    required double minHeight,
    required this.isRebuild,
  }) : maxHeight = maxHeight, minHeight = minHeight {
    assert(maxHeight >= minHeight); // maxHeight가 minHeight보다 크거나 같은지 확인
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double currentHeight = (maxHeight - shrinkOffset).clamp(minHeight, maxHeight);

    return SizedBox(
      height: currentHeight,
      child: CustomTabBar(
        tabController: tabController,
        leftTabTitle: leftTabTitle,
        rightTabTitle: rightTabTitle,
      ),
    );
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return isRebuild;
  }
}