import 'package:modakbul/models/place.dart';
import 'package:modakbul/models/friend_list.dart';
import 'package:modakbul/models/group_list.dart';

class JsonUtils {
  static List<Place> convertJsonToPlaceList(List jsonList) {
    return jsonList.map((json) => Place.fromJson(json)).toList();
  }
  List<FriendList> parseFriendList(List jsonList) {
    return jsonList.map((json) => FriendList.fromJson(json)).toList();
  }
  List<Group> parseGroupList(List jsonList) {
    return jsonList.map((json) => Group.fromJson(json)).toList();
  }
}