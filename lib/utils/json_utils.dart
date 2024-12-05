import 'package:modakbul/models/friend_list.dart';

class JsonUtils {
  List<FriendList> parseFriendList(List jsonList) {
    return jsonList.map((json) => FriendList.fromJson(json)).toList();
  }
}
