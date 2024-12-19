import 'package:modakbul/models/friend_req_list.dart';
import 'package:modakbul/models/friend_suggested.dart';


class JsonUtils {
  List<FriendReqList> parseFriendReqList(List jsonList) {
    return jsonList.map((json) => FriendReqList.fromJson(json)).toList();
  }

  List<FriendSuggested> parseFriendSuggested(List jsonList) {
    return jsonList.map((json) => FriendSuggested.fromJson(json)).toList();
  }
}
