import 'package:dio/dio.dart';
import 'package:modakbul/constants/api_path.dart';
import 'package:modakbul/core/dio_client.dart';
import 'package:modakbul/models/place.dart';
import 'package:modakbul/utils/json_utils.dart';

class KakaoService {
  Dio dio = DioClient().dio;

  Future<List<Place>> getKeywordToAddress (String query, String lat, String long) async {
    Response response = await dio.get(ApiPath.kakaoRestApi,
    options: Options(
      extra: {'skipToken': true, 'isKakao': true},
    ),
    queryParameters: {'query': query, 'y': lat, 'x': long, 'page': 1, 'size': 20},);

    print(response.data['documents']);
    return JsonUtils.convertJsonToPlaceList(response.data['documents'] as List);
  }
}