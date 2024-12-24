class AcceptModakbulResponse {
  String id;
  String status;
  Meeting meeting;
  User user;

  AcceptModakbulResponse({
    required this.id,
    required this.status,
    required this.meeting,
    required this.user,
  });

  factory AcceptModakbulResponse.fromJson(Map<String, dynamic> json) {
    return AcceptModakbulResponse(
      id: json['id'].toString() ?? '',
      status: json['status'].toString() ?? '',
      meeting: Meeting.fromJson(json['meeting']),
      user: User.fromJson(json['user']),
    );
  }
}

class Meeting {
  String id;
  String title;
  String content;
  String hostId;
  String location;
  String address;
  String detailAddress;
  DateTime date;
  String groupName;
  String lat;
  String lng;

  Meeting({
    required this.id,
    required this.title,
    required this.content,
    required this.hostId,
    required this.location,
    required this.address,
    required this.detailAddress,
    required this.date,
    required this.groupName,
    required this.lat,
    required this.lng,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      hostId: json['hostId'],
      location: json['location'],
      address: json['address'],
      detailAddress: json['detailAddress'],
      date: DateTime.parse(json['date']),
      groupName: json['groupName'],
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}

class User {
  String id;
  String userId;
  String name;
  String profileUrl;

  User({
    required this.id,
    required this.userId,
    required this.name,
    required this.profileUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      profileUrl: json['profileUrl'],
    );
  }
}
