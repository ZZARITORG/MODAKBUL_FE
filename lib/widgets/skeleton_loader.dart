import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../themes/color_schemes.dart';

class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadiusGeometry borderRadius;

  const SkeletonLoader({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: ColorSchemes.gray200,
      ),
    );
  }
}
