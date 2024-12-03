import 'package:dio/dio.dart';
import 'package:modakbul/constants/api_path.dart';
import 'package:modakbul/core/dio_client.dart';

class HealthCheckService {
  Dio dio = DioClient().dio;

  Future<void> healthCheck() async {
    await dio.get(ApiPath.healthCheck);
  }
}