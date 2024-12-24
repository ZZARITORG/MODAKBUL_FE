import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/custom_button.dart';
import 'package:modakbul/widgets/modakbul_map_screen_skeleton.dart';
import '../../themes/color_schemes.dart';

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
    final double? lat = arguments?['lat'];
    final double? lng = arguments?['lng'];

    return Scaffold(
      backgroundColor: ColorSchemes.gray000,
      appBar: BackButtonAppBar(backgroundColor: ColorSchemes.gray000),
      body: FutureBuilder(
          future: Future.delayed(
            Duration(seconds: 0),
              () => {
                'adderss': address,
                'lat': lat,
                'lng': lng,
              }
          ),
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
                              SizedBox(height: 24.h),
                              Text(
                                '모닥불이 피워진 위치를\n확인해 주세요',
                                style: Theme.of(context)
                                    .textTheme
                                    .bigHeadLine2
                                    .copyWith(color: ColorSchemes.gray500, height: 1.5),
                              ),
                              SizedBox(
                                height: 6.h,
                              ),
                              FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  address,
                                  style: Theme.of(context)
                                      .textTheme
                                      .body2
                                      .copyWith(color: ColorSchemes.orange200),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 32.h,
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
                                width: 18,
                                height: 18,
                                offsetX: 20,
                                offsetY: 20,
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
                    bottom: 69.h,
                    child: SizedBox(
                      height: 56.h,
                      child: CustomButton(
                          text: '주소 복사하기',
                          onPressed: () {},
                          buttonColor: ColorSchemes.orange200,
                          textStyle: Theme.of(context).textTheme.smallHeadLine2,
                          textColor: ColorSchemes.white),
                    ),
                  )
                ],
              );
            } else {
              return Text('머지 이거머야');
            }
          }
      ),
    );
  }
}
