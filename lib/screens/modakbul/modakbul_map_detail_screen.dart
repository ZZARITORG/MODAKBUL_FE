import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/custom_button.dart';
import 'package:modakbul/widgets/modakbul_map_screen_skeleton.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/widgets/custom_toast.dart';

class ModakbulMapDetailScreen extends StatefulWidget {
  const ModakbulMapDetailScreen({Key? key}) : super(key: key);

  @override
  State<ModakbulMapDetailScreen> createState() =>
      _ModakbulMapDetailScreenState();
}

class _ModakbulMapDetailScreenState extends State<ModakbulMapDetailScreen> {
  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  Set<Marker> markers = {};
  late KakaoMapController mapController;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String address = arguments?['address'];
    final String detailAddress = arguments?['detailAddress'];
    final String location = arguments?['location'];
    final double? lat = arguments?['lat'];
    final double? lng = arguments?['lng'];

    return Scaffold(
      backgroundColor: ColorSchemes.gray000,
      appBar: BackButtonAppBar(backgroundColor: ColorSchemes.gray000),
      body: SafeArea(
        child: FutureBuilder(
            future: Future.delayed(
                Duration(seconds: 0),
                () => {
                      'adderss': address,
                      'lat': lat,
                      'lng': lng,
                    }),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ModakbulMapScreenSkeleton();
              } else if (snapshot.hasError) {
                return Text('에러');
              } else if (snapshot.hasData) {
                return Stack(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: StyleConstants.defaultPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 16.h,
                                ),
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        address,
                                        style: Theme.of(context)
                                            .textTheme
                                            .body3
                                            .copyWith(color: ColorSchemes.gray300),
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Text(
                                        location,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bigHeadLine3
                                            .copyWith(color: ColorSchemes.orange200),
                                      ),
                                      detailAddress.replaceAll('\u200B', '').replaceAll('<...>', '').trim().isNotEmpty ? Column(
                                        children: [
                                          SizedBox(height: 4.h,),
                                          Text(
                                            detailAddress,
                                            style: Theme.of(context)
                                                .textTheme
                                                .body3
                                                .copyWith(color: ColorSchemes.orange100),
                                          ),
                                        ],
                                      ) : const SizedBox.shrink()
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Expanded(
                          child: StatefulBuilder(builder: (context, setInState) {
                            return KakaoMap(
                              onMapCreated: ((controller) async {
                                mapController = controller;
                                mapController.setZoomable(true);
                                markers.add(Marker(
                                  markerId: UniqueKey().toString(),
                                  latLng: await mapController.getCenter(),
                                  width: 40,
                                  height: 55,
                                  offsetX: 20,
                                  offsetY: 55,
                                  markerImageSrc: 'https://zzarit-madakbul-bucket.s3.ap-northeast-2.amazonaws.com/asset/pin_circle_modak.png',
                                ));
                                setInState(() {});
                              }),
                              markers: markers.toList(),
                              center: LatLng(lat!, lng!),
                            );
                          }),
                        )
                      ],
                    ),
                    Positioned(
                      left: 16.w,
                      right: 16.w,
                      bottom: 16.h,
                      child: SizedBox(
                        height: 56.h,
                        child: CustomButton(
                            text: '주소 복사하기',
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: address));
                              CustomToast.showToast(context, '주소가 복사되었습니다.', false, customBottom: 86.h);
                            },
                            buttonColor: ColorSchemes.orange200,
                            textStyle: Theme.of(context).textTheme.smallHeadLine2,
                            textColor: ColorSchemes.white),
                      ),
                    )
                  ],
                );
              } else {
                return Text('에러');
              }
            }),
      ),
    );
  }
}
