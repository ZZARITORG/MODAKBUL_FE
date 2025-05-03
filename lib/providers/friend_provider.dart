import 'dart:typed_data';

import 'package:flutter/material.dart';

class FriendProvider with ChangeNotifier {
  List<Map<String, String>> _userStatusList = [];

  List? get userStatusList => _userStatusList;

  set userStatusList(List? userStatusList) {
    print('유저스테이터스 리스트 -> $userStatusList');
    userStatusList = userStatusList;
    notifyListeners();
  }
  void updateUserStatus(String userId, String status) {
    final index = userStatusList?.indexWhere((map) => map['id'] == userId);
    if (index != null && index != -1) {
      userStatusList?[index!]['status'] = status;
      notifyListeners();
    }
  }
}