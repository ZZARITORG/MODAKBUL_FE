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
    required this.borderRadius
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: ColorSchemes.gray200,
        highlightColor: Colors.white,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: ColorSchemes.gray200,
          ),
        ));
  }
}
