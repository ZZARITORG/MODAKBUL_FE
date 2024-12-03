import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:modakbul/constants/api_path.dart';
import 'package:modakbul/core/dio_client.dart';
import 'package:modakbul/utils/date_time_utils.dart';
import 'package:modakbul/utils/string_utils.dart';

class AwsService {
  Dio dio = DioClient().dio;

  Future<String> uploadProfileImage(Uint8List profileImage) async {
    ///Presigned URL 가져오기
    String dateTime = await DateTimeUtils.getKoreaTimeForUrl();
    String randomString = StringUtils().generateRandomString();
    Response response = await dio.get(
      ApiPath.getPresignedUrl(
          dateTime + randomString),
      options: Options(
        extra: {'skipToken': true},
      ),
    );

    String presignedUrl = response.data['data'];

    ///Presigned URL로 이미지 업로드 TODO:시간으로 변경
    await uploadImageToS3(presignedUrl, profileImage);
    return '${ApiPath.s3Url}/${dateTime + randomString}';
  }

  Future<void> uploadImageToS3(
      String presignedUrl, Uint8List profileImage) async {
    await dio.put(
      presignedUrl,
      data: profileImage,
      options: Options(
        extra: {'skipToken': true},
        contentType: 'image/jpeg',
        headers: {
          'Content-Length': profileImage.length.toString(),
        },
      ),
    );
  }
}
