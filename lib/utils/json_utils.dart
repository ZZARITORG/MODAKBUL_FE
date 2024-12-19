import 'package:modakbul/models/friend_req_list.dart';


class JsonUtils {
  List<FriendReqList> parseFriendReqList(List jsonList) {
    return jsonList.map((json) => FriendReqList.fromJson(json)).toList();
  }
}
