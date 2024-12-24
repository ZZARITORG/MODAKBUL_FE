import 'package:modakbul/models/address.dart';
import 'package:modakbul/models/place.dart';
import 'package:modakbul/models/friend_list.dart';
import 'package:modakbul/models/group_list.dart';
import 'package:modakbul/models/accepted_modakbul.dart';
import 'package:modakbul/models/my_host_modakbul.dart';
import 'package:modakbul/models/pending_modakbul.dart';

import '../models/modakbul_detail.dart';

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
  static List<Address> convertJsonToAddress(List jsonList) {
    return jsonList.map((json) => Address.fromJson(json)).toList();
  }

  List<MyHostModakbul> parseMyHostModakbulList(List<dynamic> jsonList) {
    return jsonList.map((json) => MyHostModakbul.fromJson(json)).toList();
  }

  List<AcceptedModakbul> parseAcceptedModakbulList(List<dynamic> jsonList) {
    return jsonList.map((json) => AcceptedModakbul.fromJson(json)).toList();
  }

  List<PendingModakbul> parsePendingModakbulList(List<dynamic> jsonList) {
    return jsonList.map((json) => PendingModakbul.fromJson(json)).toList();
  }

  ModakbulDetail parseModakbulDetail(Map<String, dynamic> json) {
    return ModakbulDetail.fromJson(json);
  }
}

