import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:modakbul/constants/api_path.dart';
import 'package:modakbul/constants/app_constants.dart';
import 'package:modakbul/models/login.dart';
import 'package:modakbul/models/refresh_token_request.dart';
import 'package:modakbul/models/refresh_token_response.dart';
import 'package:modakbul/models/tokens.dart';

import 'dio_client.dart';

class DioInterceptor extends InterceptorsWrapper {
  Logger logger = Logger(
    printer: PrettyPrinter(),
  );

  FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // 요청 전 처리
    if (options.extra['skipToken'] != true) {
      String? token = await secureStorage.read(key: AppConstants.accessToken);
      options.headers['Authorization'] = 'Bearer $token';
    }
    if (options.extra['isKakao'] == true) {
      String kakaoRestApiKey = dotenv.env['KAKAO_REST_API_KEY'] ?? '';
      options.headers['Authorization'] = 'KakaoAK $kakaoRestApiKey';
    }
    return super.onRequest(options, handler);
  }

  @override
  onResponse(Response response, ResponseInterceptorHandler handler) {
    // 응답 처리 (필요한 경우 로직 구현)
    return super.onResponse(response, handler);
  }

  ///TODO: 에러핸들링 어떻게할지 논의
  @override
  onError(DioException originalException, ErrorInterceptorHandler originalHandler) async {
    // 에러 처리
    logger.e('DIO 에러 : ${originalException.type}');
    switch (originalException.type) {
      case DioExceptionType.cancel:
        logger.e('API 호출 취소');
        break;
      case DioExceptionType.connectionTimeout:
        logger.e('API 연결 시간 초과');
        break;
      case DioExceptionType.unknown:
        logger.e('인터넷 연결 문제');
        break;
      case DioExceptionType.receiveTimeout:
        logger.e('API 수신 시간 초과');
        break;
      case DioExceptionType.sendTimeout:
        logger.e('API 요청 시간 초과');
        break;
      case DioExceptionType.badResponse:
        int statusCode = originalException.response?.statusCode ?? 0;
        switch (statusCode) {
          case 401:
            logger.e('$statusCode 인증 오류');

            try {
              String? refreshToken = await secureStorage.read(key: AppConstants.refreshToken);
              if (refreshToken == null) {
                return originalHandler.resolve(
                  Response(
                    requestOptions: originalException.requestOptions,
                    data: {'data': []},
                    statusCode: 200,
                  ),
                );
              }

              final refreshDio = Dio(BaseOptions(
                baseUrl: ApiPath.baseUrl,
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
              ));

              final response = await refreshDio.post(
                ApiPath.tokenRefresh,
                data: RefreshTokenRequest(refreshToken: refreshToken).toJson(),
              );

              final refreshResponse = RefreshTokenResponse.fromJson(response.data['data']);
              await secureStorage.write(
                  key: AppConstants.accessToken,
                  value: refreshResponse.accessToken
              );

              // 토큰 갱신 성공 후 원래 요청 다시 시도
              final newDio = Dio(BaseOptions(
                baseUrl: ApiPath.baseUrl,
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
              ));

              // 원래 요청의 모든 설정을 유지하면서 새 토큰만 업데이트
              final originalOptions = originalException.requestOptions;
              originalOptions.headers['Authorization'] = 'Bearer ${refreshResponse.accessToken}';

              try {
                final retryResponse = await newDio.fetch(originalOptions);
                return originalHandler.resolve(retryResponse);
              } catch (retryError) {
                logger.e('재시도 요청 실패: $retryError');
                return originalHandler.resolve(
                  Response(
                    requestOptions: originalException.requestOptions,
                    data: {'data': []},
                    statusCode: 200,
                  ),
                );
              }
            } catch (e) {
              logger.e('토큰 갱신 실패: $e');
              String? phoneNumber =
              await secureStorage.read(key: AppConstants.phoneNumber);
              // 개발자 권한 받으면 변경 예정
              String? fcmToken;
              if (Platform.isIOS) {
                // await Future.delayed(Duration(seconds: 2));
                fcmToken = await FirebaseMessaging.instance.getToken();
                print('APNS Token: $fcmToken');
              } else if (Platform.isAndroid) {
                fcmToken = await FirebaseMessaging.instance.getToken();
              }
              final refreshDio = Dio(BaseOptions(
                baseUrl: ApiPath.baseUrl,
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
              ));
              Response response = await refreshDio.post(
                ApiPath.login,
                data: Login(phoneNo: phoneNumber!, fcmToken: fcmToken!).toJson(),
              );
              Tokens tokens = Tokens.fromJson(response.data['data']);
              await Future.wait([
                secureStorage.write(
                    key: AppConstants.accessToken, value: tokens.accessToken),
                secureStorage.write(
                    key: AppConstants.refreshToken,
                    value: tokens.refreshToken),
              ]);
              final newDio = Dio(BaseOptions(
                baseUrl: ApiPath.baseUrl,
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
              ));

              originalException.requestOptions.headers['Authorization'] =
              'Bearer ${tokens.accessToken}';
              Response clonedRequest = await newDio.fetch(originalException.requestOptions);

              return originalHandler.resolve(clonedRequest);
            }

          case 404:
            logger.e('$statusCode API 경로 오류');
            break;
          case 500:
            logger.e('$statusCode 서버 오류');
            break;
          default:
            logger.e('$statusCode 알수없는 오류');
            break;
        }
        break;
      default:
        logger.e('알수 없는 오류 발생');
        break;
    }
    return super.onError(originalException, originalHandler);
  }
}
