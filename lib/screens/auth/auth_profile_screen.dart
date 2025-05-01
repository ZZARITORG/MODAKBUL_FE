import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modakbul/constants/api_path.dart';
import 'package:modakbul/constants/app_constants.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/constants/style_constants.dart';
import 'package:modakbul/models/tokens.dart';
import 'package:modakbul/models/user.dart';
import 'package:modakbul/providers/auth_provider.dart';
import 'package:modakbul/routes/routes.dart';
import 'package:modakbul/services/auth_service.dart';
import 'package:modakbul/services/aws_service.dart';
import 'package:modakbul/themes/color_schemes.dart';
import 'package:modakbul/themes/styles.dart';
import 'package:modakbul/utils/image_picker_utils.dart';
import 'package:modakbul/widgets/back_button_app_bar.dart';
import 'package:modakbul/widgets/custom_button.dart';
import 'package:modakbul/widgets/custom_toast.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class AuthProfileScreen extends StatefulWidget {
  const AuthProfileScreen({super.key});

  @override
  State<AuthProfileScreen> createState() => _AuthProfileScreenState();
}

class _AuthProfileScreenState extends State<AuthProfileScreen> {
  ImagePickerUtils imagePickerUtils = ImagePickerUtils();
  XFile? _imageFile;
  late AuthProvider authProvider;
  AwsService awsService = AwsService();
  AuthService authService = AuthService();
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  bool _isButtonEnabled = true;

  _handleButtonPress() async {
    try {
      _isButtonEnabled = false;
      if (authProvider.isDefaultProfile!) {
        authProvider.profileUrl = '${ApiPath.s3Url}/default';
      } else {
        authProvider.profileUrl =
        await awsService.uploadProfileImage(authProvider.profileImage!);
      }
      // 개발자 권한 받으면 변경 예정
      String? fcmToken;
      if (Platform.isIOS) {
        // await Future.delayed(Duration(seconds: 2));
        fcmToken = await FirebaseMessaging.instance.getToken();
        print('APNS Token: $fcmToken');
      } else if (Platform.isAndroid) {
        fcmToken = await FirebaseMessaging.instance.getToken();
      }
      Tokens tokens = await authService.signUp(User(
          userId: authProvider.userId!,
          name: authProvider.userName!,
          phoneNo: authProvider.phoneNumber!,
          profileUrl: authProvider.profileUrl!,
          fcmToken: [fcmToken!],
          isFriendAlarm: true,
          isContactAgree: true));

    if (tokens.accessToken.isNotEmpty && tokens.accessToken.isNotEmpty) {
      print('회원가입 시 저장되는 전화번호: ${authProvider.phoneNumber}');
      await Future.wait([
        secureStorage.write(
            key: AppConstants.accessToken, value: tokens.accessToken),
        secureStorage.write(
            key: AppConstants.refreshToken, value: tokens.refreshToken),
        secureStorage.write(
            key: AppConstants.phoneNumber, value: authProvider.phoneNumber!),
      ]);

      await Future.wait([
        FirebaseMessaging.instance.subscribeToTopic(AppConstants.modakbulAlertTopic),
        FirebaseMessaging.instance.subscribeToTopic(AppConstants.adAlertTopic),
        prefs.setStringList('delSugList', []),
        prefs.setString(AppConstants.userName, authProvider.userName!),
        prefs.setString(AppConstants.userId, authProvider.userId!),
        prefs.setString(AppConstants.profileUrl, authProvider.profileUrl!),
        prefs.setString(AppConstants.phoneNumber, authProvider.phoneNumber!),
        prefs.setBool(AppConstants.isFriendAlarm, true),
        prefs.setBool(AppConstants.isContactAgree, true),
        prefs.setBool(AppConstants.isAllAlertToggled, true),
        prefs.setBool(AppConstants.isModakbulAlertToggled, true),
        prefs.setBool(AppConstants.isAdAlertToggled, true),
      ]);

        if (!context.mounted) return;
        Routes.navigateAndRemoveUntil(context, Routes.mainScreen);
      }
    } catch (e) {
      CustomToast.showToast(context, '회원가입에 실패하였습니다', false, customBottom: 86.h);
    } finally {
      // 비동기 작업이 끝난 후 버튼을 활성화
      setState(() {
        _isButtonEnabled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: const BackButtonAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: StyleConstants.defaultPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 42.h,
              ),
              Text('프로필 사진을 선택해주세요',
                  style: Theme.of(context)
                      .textTheme
                      .bigHeadLine3
                      .copyWith(color: ColorSchemes.gray500)),
              SizedBox(
                height: 6.h,
              ),
              Text('사용자님의 모습을 표현해 보세요.',
                  style: Theme.of(context)
                      .textTheme
                      .body2
                      .copyWith(color: ColorSchemes.gray200)),
              SizedBox(
                height: 73.h,
              ),
              Center(
                child: InkWell(
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  onTap: () async {
                    _imageFile = await imagePickerUtils.pickImage(
                      ImageSource.gallery,
                    );
                    if (_imageFile != null) {
                      Uint8List? imageBytes = await _imageFile!.readAsBytes();
                      //마운트 체크
                      if (!context.mounted) return;
                      Routes.navigateTo(context, Routes.imageCropperScreen,
                          arguments: imageBytes);
                    }
                  },
                  child: CircleAvatar(
                    radius: StyleConstants.circleSizeXXXL,
                    backgroundColor: ColorSchemes.orange100,
                    child: CircleAvatar(
                      radius: 120.r,
                      backgroundColor: ColorSchemes.white,
                      backgroundImage: authProvider.profileImage != null
                          ? MemoryImage(authProvider.profileImage!)
                          : null,
                      child: authProvider.profileImage != null
                          ? null
                          : Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                      height: 54.r,
                                      width: 54.r,
                                      child: SvgPicture.asset(
                                        IconPath.photoCameraOrange200,
                                        width: 37.r,
                                        fit: BoxFit.scaleDown,
                                      )),
                                  Text(
                                    '사진올리기',
                                    style: Theme.of(context)
                                        .textTheme
                                        .body2
                                        .copyWith(
                                            color: ColorSchemes.orange200),
                                  )
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Center(
                child: TextButton(
                    onPressed: () async {
                      ByteData defalutProfile = await rootBundle
                          .load('assets/images/default_profile.jpg');

                      // ByteData를 Uint8List로 변환
                      Uint8List uint8list = defalutProfile.buffer.asUint8List(
                          defalutProfile.offsetInBytes,
                          defalutProfile.lengthInBytes);
                      authProvider.profileImage = uint8list;
                      authProvider.isDefaultProfile = true;
                    },
                    child: Text(
                      '기본이미지 선택하기',
                      style: Theme.of(context)
                          .textTheme
                          .smallHeadLine3
                          .copyWith(color: ColorSchemes.orange100),
                    )),
              ),
              SizedBox(
                height: 14.h,
              ),
              SizedBox(
                height: 56.h,
                width: double.infinity,
                child: CustomButton(
                  text: '회원가입 완료',
                  onPressed: authProvider.profileImage != null && _isButtonEnabled
                      ? _handleButtonPress
                      : null,
                  buttonColor: ColorSchemes.orange200,
                  textStyle: Theme.of(context).textTheme.smallHeadLine2,
                  textColor: ColorSchemes.white,
                ),
              ),
              SizedBox(
                height: 16.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}
