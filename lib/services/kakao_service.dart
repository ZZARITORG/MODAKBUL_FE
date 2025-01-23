import 'package:dio/dio.dart';
import 'package:modakbul/constants/api_path.dart';
import 'package:modakbul/core/dio_client.dart';
import 'package:modakbul/models/address.dart';
import 'package:modakbul/models/place.dart';
import 'package:modakbul/utils/json_utils.dart';

class KakaoService {
  Dio dio = DioClient().dio;

  Future<Map<String, dynamic>> getKeywordToAddress (String query, String lat, String long, String sort, int page) async {
    Response response = await dio.get(ApiPath.kakaoRestApi + ApiPath.keywordToAddress,
    options: Options(
      extra: {'skipToken': true, 'isKakao': true},
    ),
    queryParameters: {'query': query, 'y': lat, 'x': long, 'page': page, 'size': 15, 'sort': sort},);

    print(response.data);
    return response.data;
  }

  Future<List<Address>> getCoordToAddress (String lat, String long) async {
    print(lat);
    print(long);
    Response response = await dio.get(ApiPath.kakaoRestApi + ApiPath.coordToAddress,
      options: Options(
        extra: {'skipToken': true, 'isKakao': true},
      ),
      queryParameters: {'y': lat, 'x': long,},);

    print(response);
    return JsonUtils.convertJsonToAddress(response.data['documents'] as List);
  }
}