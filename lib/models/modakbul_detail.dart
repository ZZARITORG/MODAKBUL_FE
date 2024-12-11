import 'package:logger/logger.dart';

class ModakbulDetail {
  String id;
  String title;
  String content;
  String hostId;
  String location;
  String address;
  String detailAddress;
  DateTime date;
  List<UserStatus> users;
  double lat;
  double lng;

  ModakbulDetail({
    required this.id,
    required this.title,
    required this.content,
    required this.hostId,
    required this.location,
    required this.address,
    required this.detailAddress,
    required this.date,
    required this.users,
    required this.lat,
    required this.lng,
  });

  factory ModakbulDetail.fromJson(Map<String, dynamic> json) {
    Logger logger = Logger();
    logger.i(json['lat'].runtimeType);
    logger.i(json['lng']);
    return ModakbulDetail(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      hostId: json['hostId'],
      location: json['location'],
      address: json['address'],
      detailAddress: json['detailAddress'],
      date: DateTime.parse(json['date']),
      users: (json['user'] as List)
          .map((userJson) => UserStatus.fromJson(userJson))
          .toList(),
      lat: (json['lat'] is String ? double.tryParse(json['lat']) : json['lat']) ?? 0.0,
      lng: (json['lng'] is String ? double.tryParse(json['lng']) : json['lng']) ?? 0.0,
    );
  }
}

class UserStatus {
  String id;
  String userId;
  String name;
  String profileUrl;
  String status;

  UserStatus({
    required this.id,
    required this.userId,
    required this.name,
    required this.profileUrl,
    required this.status,
  });

  factory UserStatus.fromJson(Map<String, dynamic> json) {
    return UserStatus(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      profileUrl: json['profileUrl'],
      status: json['status'],
    );
  }
}
