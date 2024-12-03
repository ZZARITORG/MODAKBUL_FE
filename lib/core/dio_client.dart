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
}
