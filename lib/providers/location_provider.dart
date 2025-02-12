import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider extends ChangeNotifier {
  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  Stream<Position>? _positionStream;
  // 위치 초기화 완료 여부를 추적하는 Future
  Future<void>? _initLocationFuture;
  Future<void>? get initLocationFuture => _initLocationFuture;

  LocationProvider() {
    _initLocationFuture = startTracking();
  }

  Future<void> startTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    // 현재 위치를 가져오고 초기화가 완료될 때까지 기다림
    _currentPosition = await Geolocator.getCurrentPosition();
    notifyListeners();

    // 스트림 설정
    _positionStream = Geolocator.getPositionStream();
    _positionStream?.listen((Position position) {
      print('위도: ${position.latitude}, 경도: ${position.longitude}');
      _currentPosition = position;
      notifyListeners();
    });
  }

  // 위치 정보 강제 새로고침
  Future<Position?> refreshLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition();
      notifyListeners();
      return _currentPosition;
    } catch (e) {
      print('위치 새로고침 실패: $e');
      return null;
    }
  }
}