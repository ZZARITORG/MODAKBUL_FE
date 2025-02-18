import 'package:flutter/material.dart';

class MeetingProvider with ChangeNotifier {
  String? _selectGroupName;
  String? _selectGroupId;
  List<Map<String, String>>? _selectFriends;
  bool? _isGroup;
  String? _selectPlace;
  DateTime? _selectDate;
  String? _selectHour;
  String? _selectMinute;
  String? _selectAddress; // 추가
  String? _selectDetailAddress; // 추가
  double? _selectLat; // 추가
  double? _selectLng; // 추가

  // Getters
  String? get selectGroupName => _selectGroupName;
  String? get selectGroupId => _selectGroupId;
  List<Map<String, String>>? get selectFriends => _selectFriends;
  bool? get isGroup => _isGroup;
  String? get selectPlace => _selectPlace;
  DateTime? get selectDate => _selectDate;
  String? get selectHour => _selectHour;
  String? get selectMinute => _selectMinute;
  String? get selectAddress => _selectAddress;
  String? get selectDetailAddress => _selectDetailAddress;
  double? get selectLat => _selectLat;
  double? get selectLng => _selectLng;

  // Setters
  set selectGroupName(String? selectGroupName) {
    _selectGroupName = selectGroupName;
    notifyListeners();
  }

  set selectGroupId(String? selectGroupId) {
    _selectGroupId = selectGroupId;
    notifyListeners();
  }

  set selectFriends(List<Map<String, String>>? selectFriends) {
    _selectFriends = selectFriends;
    notifyListeners();
  }

  set isGroup(bool? isGroup) {
    _isGroup = isGroup;
    notifyListeners();
  }

  set selectPlace(String? selectPlace) {
    _selectPlace = selectPlace;
    notifyListeners();
  }

  set selectDate(DateTime? selectDate) {
    _selectDate = selectDate;
    notifyListeners();
  }

  set selectHour(String? selectHour) {
    _selectHour = selectHour;
    notifyListeners();
  }

  set selectMinute(String? selectMinute) {
    _selectMinute = selectMinute;
    notifyListeners();
  }

  set selectAddress(String? selectAddress) {
    _selectAddress = selectAddress;
    notifyListeners();
  }

  set selectDetailAddress(String? selectDetailAddress) {
    _selectDetailAddress = selectDetailAddress;
    notifyListeners();
  }

  set selectLat(double? selectLat) {
    _selectLat = selectLat;
    notifyListeners();
  }

  set selectLng(double? selectLng) {
    _selectLng = selectLng;
    notifyListeners();
  }

  void reset() {
    _selectGroupName = null;
    _selectGroupId = null;
    _selectFriends = null;
    _isGroup = null;
    _selectPlace = null;
    _selectDate = null;
    _selectHour = null;
    _selectMinute = null;
    _selectAddress = null;
    _selectDetailAddress = null;
    _selectLat = null;
    _selectLng = null;
    notifyListeners();
  }
}
