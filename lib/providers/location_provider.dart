import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider extends ChangeNotifier {
  Position? _currentPosition;

  Position? get currentPosition => _currentPosition;

  Stream<Position>? _positionStream;

  LocationProvider() {
    startTracking();
  }

  void startTracking() async {
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

    Position position = await Geolocator.getCurrentPosition();
    _currentPosition = position;
    notifyListeners();

    _positionStream?.listen((Position position) {
      print('위도: ${position.latitude}, 경도: ${position.longitude}');
      _currentPosition = position;
    });
  }
}