import 'package:geolocator/geolocator.dart';

class LocationUtils {

  Stream<Position>? positionStream;

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

    positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // 최소 10미터 이동 시 업데이트
      ),
    );

    positionStream?.listen((Position position) {
      print('위도: ${position.latitude}, 경도: ${position.longitude}');
    });
  }

}
