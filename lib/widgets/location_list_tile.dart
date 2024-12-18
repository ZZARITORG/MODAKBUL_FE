import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/main.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';

class LocationListTile extends StatelessWidget {
  final String locationName;
  final String address;
  final String distance;
  final VoidCallback? onPressed;
  final bool isGrayIcon;

  factory LocationListTile.isGrayIcon({
    required String locationName,
    required String address,
    required distance,
    required VoidCallback onPressed,
  }) =>
      LocationListTile(locationName: locationName,
        address: address,
        distance: distance,
        onPressed: onPressed,
        isGrayIcon: true,);

  const LocationListTile({Key? key,
    required this.locationName,
    required this.address,
    required this.distance,
    this.onPressed,
    this.isGrayIcon = false,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 24.r,
                width: 24.r,
                child: Center(
                  child: SvgPicture.asset(
                    isGrayIcon ? IconPath.pinDropGray200 : IconPath.pinDropOrange200,
                    width: 16.r,
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            locationName,
                            overflow: TextOverflow.ellipsis,
                            style: Theme
                                .of(context)
                                .textTheme
                                .smallHeadLine2
                                .copyWith(color: ColorSchemes.gray500),
                          ),
                        ),

                        ///이거 너비 정해야댐
                        SizedBox(
                          width: 6.h,
                        ),
                        Text(
                          distance,
                          style: Theme
                              .of(context)
                              .textTheme
                              .caption
                              .copyWith(color: ColorSchemes.gray200),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          //주소가 없는 곳이있으면 fittedbox가 고장나기때문에 삼항연산자
                          address == '' ? ' ' : address,
                          style: Theme
                              .of(context)
                              .textTheme
                              .caption
                              .copyWith(color: ColorSchemes.gray400),
                          maxLines: 1,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(width: 16.w,),
              if(isGrayIcon)
                SizedBox(
                  height: 18.r,
                  width: 18.r,
                  child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: onPressed,
                      icon: SvgPicture.asset(
                        IconPath.deleteForever, width: 10.r,
                      )),
                )
            ],
          ),
        ),
        Divider(height: 2.h, thickness: 2.h, color: ColorSchemes.gray100,)
      ],
    );
  }
}
