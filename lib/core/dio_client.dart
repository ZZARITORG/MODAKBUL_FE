import 'package:dio/dio.dart';
import 'package:modakbul/constants/api_path.dart';

import 'dio_interceptor.dart';

///Singleton Pattern으로 하나의 인스턴스만 생성
class DioClient {
  static final DioClient _instance = DioClient._internal();
  late Dio dio;

  factory DioClient() {
    return _instance;
  }

  //카카오 api 쓸경우 dio 따로 처리
  DioClient._internal() {
    BaseOptions baseOptions = BaseOptions(
      baseUrl: ApiPath.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      responseType: ResponseType.json,
    );

    dio = Dio(baseOptions);
    dio.interceptors.clear();
    dio.interceptors.add(DioInterceptor());
  }

  Future<T> handleRequest<T>({
    required Future<T> Function() requestFunction,
    //required Function(String) onError,
  }) async {
    try {
      return await requestFunction();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // 토큰 갱신 시도 후 원래 요청 재시도
        try {
          // DioInterceptor에서 토큰 갱신 처리를 기다림
          return await requestFunction();
        } catch (retryError) {
          //onError('인증에 실패했습니다. 다시 로그인해주세요.');
          rethrow;
        }
      }
      //onError('요청 처리 중 오류가 발생했습니다.');
      rethrow;
    } catch (e) {
      //onError('알 수 없는 오류가 발생했습니다.');
      rethrow;
    }
  }
}
