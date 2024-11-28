import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? _phoneNumber;
  String? _userName;
  String? _userId;

  String? get phoneNumber => _phoneNumber;
  String? get userName => _userName;
  String? get userId => _userId;

  set phoneNumber (String? phoneNumber) {
    _phoneNumber = phoneNumber;
    notifyListeners();
  }

  set userName (String? userName) {
    _userName = userName;
    notifyListeners();
  }

  set userId (String? userId) {
    _userId = userId;
    notifyListeners();
  }
}