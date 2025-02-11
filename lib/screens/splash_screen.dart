import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:modakbul/constants/app_constants.dart';
import 'package:modakbul/constants/assets_path.dart';
import 'package:modakbul/routes/routes.dart';
import 'package:modakbul/services/health_check_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  HealthCheckService healthCheckService = HealthCheckService();
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Logger logger = Logger(
    printer: PrettyPrinter(),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (prefs.getBool('first_run') ?? true) {
        FlutterSecureStorage secureStorage = const FlutterSecureStorage();

        await secureStorage.deleteAll();

        prefs.setBool('first_run', false);
      }
      String? accessToken = await secureStorage.read(key: AppConstants.accessToken);
      String? refreshToken = await secureStorage.read(key: AppConstants.refreshToken);
      String? phoneNumber = await secureStorage.read(key: AppConstants.phoneNumber);
      logger.d('accessToken: $accessToken');
      logger.d('refreshToken: $refreshToken');
      logger.d('phoneNumber: $phoneNumber');

      if (accessToken != null && refreshToken != null && phoneNumber != null) {
        logger.d('자동 로그인 o');
        try {
          await healthCheckService.healthCheck();

          await prefs.setString(AppConstants.phoneNumber, phoneNumber);

          if(!context.mounted) return;
          Routes.navigateSplashReplacement(context, Routes.mainScreen);
        } catch (e) {
          if(!context.mounted) return;
          Routes.navigateSplashReplacement(context, Routes.authPhoneScreen);
        }
      } else {
        logger.d('자동 로그인 x');
        if(!context.mounted) return;
        Routes.navigateSplashReplacement(context, Routes.authPhoneScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(
          IconPath.modakbulLogo,
          width: 171.r,
        ),
      ),
    );
  }
}
