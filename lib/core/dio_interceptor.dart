import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:modakbul/constants/api_path.dart';
import 'package:modakbul/constants/app_constants.dart';
import 'package:modakbul/models/login.dart';
import 'package:modakbul/models/phone_number.dart';
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
      String? token = await secureStorage.read(key: 'ACCESS_TOKEN');
      options.headers['Authorization'] = 'Bearer $token';
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

            ///TODO: Token 갱신 구현
            //String? accessToken = await secureStorage.read(key: 'ACCESS_TOKEN');
            String? refreshToken =
            await secureStorage.read(key: 'REFRESH_TOKEN');

            // 토큰 갱신 요청을 담당할 dio 객체 구현 후 그에 따른 interceptor 정의
            BaseOptions baseOptions = BaseOptions(
              baseUrl: ApiPath.baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              responseType: ResponseType.json,
            );

            Dio refreshDio = Dio(baseOptions);

            Dio dio = DioClient().dio;
            dio.interceptors.clear();

            refreshDio.interceptors.clear();
            refreshDio.interceptors
                .add(InterceptorsWrapper(onError: (exception, handler) async {
              // 다시 인증 오류가 발생했을 경우: RefreshToken의 만료
              if (exception.response?.statusCode == 401) {
                logger.e('$statusCode 리프레시 인증 오류');
                // 기기의 자동 로그인 정보 삭제 시나리오
                //await secureStorage.deleteAll();

                // . . .
                // 로그인 만료 dialog 발생 후 로그인 페이지로 이동
                // . . .
                String? phoneNumber =
                await secureStorage.read(key: AppConstants.phoneNumber);
                String? fcmToken = await FirebaseMessaging.instance.getToken();
                Response response = await refreshDio.post(
                  ApiPath.login,
                  data: Login(phoneNo: phoneNumber!, fcmToken: fcmToken!),
                  options: Options(
                    extra: {'skipToken': true},
                  ),
                );
                Tokens tokens = Tokens.fromJson(response.data['data']);
                await Future.wait([
                  secureStorage.write(
                      key: AppConstants.accessToken, value: tokens.accessToken),
                  secureStorage.write(
                      key: AppConstants.refreshToken,
                      value: tokens.refreshToken),
                ]);

                originalException.requestOptions.headers['Authorization'] =
                'Bearer ${tokens.accessToken}';
                Response clonedRequest = await dio.fetch(originalException.requestOptions);

                return originalHandler.resolve(clonedRequest);
              }
              return handler.reject(exception);
            }));

            Response response = await refreshDio.post(
              ApiPath.tokenRefresh,
              data: RefreshTokenRequest(refreshToken: refreshToken!).toJson(),
            );

            RefreshTokenResponse refreshResponse =
            RefreshTokenResponse.fromJson(response.data['data']);
            logger.d('refreshResponse: ${refreshResponse.accessToken}');

            await secureStorage.write(
                key: AppConstants.accessToken,
                value: refreshResponse.accessToken);

            originalException.requestOptions.headers['Authorization'] =
            'Bearer ${refreshResponse.accessToken}';
            Response clonedRequest = await dio.fetch(originalException.requestOptions);

            // API 복사본으로 재요청
            logger.d('clonedRequest: ${clonedRequest.data}');
            return originalHandler.resolve(clonedRequest);

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
