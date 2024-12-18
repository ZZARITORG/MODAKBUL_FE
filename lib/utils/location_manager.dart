import 'dart:convert';
import 'package:modakbul/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationManager {
  static const String _locationsKey = 'locations';
  static const int _maxLocations = 10;

  /// 장소 데이터를 추가
  static Future<void> addLocation(Map<String, dynamic> location) async {
    List<String> locations = prefs.getStringList(_locationsKey) ?? [];

    // 저장된 데이터를 디코딩하여 중복 확인
    List<Map<String, dynamic>> decodedLocations =
    locations.map((loc) => jsonDecode(loc) as Map<String, dynamic>).toList();

    // x와 y가 겹치는 데이터가 있는지 확인
    bool isDuplicate = decodedLocations.any((existingLocation) =>
    existingLocation['x'] == location['x'] &&
        existingLocation['y'] == location['y']);

    // 중복된 데이터라면 추가하지 않음
    if (isDuplicate) {
      print('중복된 위치입니다. 추가하지 않습니다.');
      return;
    }

    // 새로운 장소 데이터를 JSON 문자열로 변환 후 추가
    locations.add(jsonEncode(location));

    // 10개 초과 시 가장 오래된 데이터 삭제
    if (locations.length > _maxLocations) {
      locations.removeAt(0); // 첫 번째 데이터 삭제
    }

    // 변경된 리스트 저장
    await prefs.setStringList(_locationsKey, locations);
  }

  /// 저장된 모든 장소 데이터 가져오기
  static List<Map<String, dynamic>> getLocations() {
    List<String> locations = prefs.getStringList(_locationsKey) ?? [];
    return locations.map((loc) => jsonDecode(loc) as Map<String, dynamic>).toList();
  }

  /// 모든 데이터 삭제
  static Future<void> clearLocations() async {
    await prefs.remove(_locationsKey);
  }
}
