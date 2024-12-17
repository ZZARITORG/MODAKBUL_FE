import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:modakbul/constants/api_path.dart';
import 'package:modakbul/core/dio_client.dart';
import 'package:modakbul/models/group_list.dart';
import 'package:modakbul/models/uuid.dart';
import 'package:modakbul/utils/json_utils.dart';

class GroupService {
  Dio dio = DioClient().dio;

  Future<List<Group>> getGroupList() async {
    Response response = await dio.get(
        ApiPath.group,
    );
    return JsonUtils().parseGroupList(response.data['data'] as List);
  }
}

