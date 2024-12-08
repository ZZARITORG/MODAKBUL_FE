class AcceptedModakbul {
  String id;
  String title;
  String content;
  String hostId;
  String location;
  String address;
  String detailAddress;
  DateTime date;
  List<UserStatus> users;

  AcceptedModakbul({
    required this.id,
    required this.title,
    required this.content,
    required this.hostId,
    required this.location,
    required this.address,
    required this.detailAddress,
    required this.date,
    required this.users,
  });

  factory AcceptedModakbul.fromJson(Map<String, dynamic> json) {
    return AcceptedModakbul(
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
