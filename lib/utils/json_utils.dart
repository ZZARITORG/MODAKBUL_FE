import 'package:modakbul/models/accepted_modakbul.dart';
import 'package:modakbul/models/my_host_modakbul.dart';
import 'package:modakbul/models/pending_modakbul.dart';

class JsonUtils {
  List<MyHostModakbul> parseMyHostModakbulList(List<dynamic> jsonList) {
    return jsonList.map((json) => MyHostModakbul.fromJson(json)).toList();
  }

  List<AcceptedModakbul> parseAcceptedModakbulList(List<dynamic> jsonList) {
    return jsonList.map((json) => AcceptedModakbul.fromJson(json)).toList();
  }

  List<PendingModakbul> parsePendingModakbulList(List<dynamic> jsonList) {
    return jsonList.map((json) => PendingModakbul.fromJson(json)).toList();
  }
}
