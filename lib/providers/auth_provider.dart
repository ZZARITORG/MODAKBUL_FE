import 'dart:typed_data';

import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? _phoneNumber;
  String? _userName;
  String? _userId;
  Uint8List? _profileImage;
  String? _profileUrl;
  bool? _isDefaultProfile;

  String? get phoneNumber => _phoneNumber;
  String? get userName => _userName;
  String? get userId => _userId;
  Uint8List? get profileImage => _profileImage;
  String? get profileUrl => _profileUrl;
  bool? get isDefaultProfile => _isDefaultProfile;

  set phoneNumber(String? phoneNumber) {
    _phoneNumber = phoneNumber;
    notifyListeners();
  }

  set userName(String? userName) {
    _userName = userName;
    notifyListeners();
  }

  set userId(String? userId) {
    _userId = userId;
    notifyListeners();
  }

  set profileImage(Uint8List? profileImage) {
    _profileImage = profileImage;
    notifyListeners();
  }

  set profileUrl(String? profileUrl) {
    _profileUrl = profileUrl;
    notifyListeners();
  }

  set isDefaultProfile(bool? isDefaultProfile) {
    _isDefaultProfile = isDefaultProfile;
    notifyListeners();
  }
}