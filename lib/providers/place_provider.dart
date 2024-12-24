import 'package:flutter/material.dart';

class PlaceProvider with ChangeNotifier {
  double? _distance;
  double? _x;
  double? _y;
  String? _roadAddressName;
  String? _placeName;
  String? _detailAddressName;

  double? get distance => _distance;
  double? get x => _x;
  double? get y => _y;
  String? get roadAddressName => _roadAddressName;
  String? get placeName => _placeName;
  String? get detailAddressName => _detailAddressName;

  set distance(double? distance) {
    _distance = distance;
    notifyListeners();
  }

  set x(double? x) {
    _x = x;
    notifyListeners();
  }

  set y(double? y) {
    _y = y;
    notifyListeners();
  }

  set roadAddressName(String? roadAddressName) {
    _roadAddressName = roadAddressName;
    notifyListeners();
  }

  set placeName(String? placeName) {
    _placeName = placeName;
    notifyListeners();
  }

  set detailAddressName(String? detailAddressName) {
    _detailAddressName = detailAddressName;
    notifyListeners();
  }
}