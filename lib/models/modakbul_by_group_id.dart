class ModakbulByGroupId {
  String title;
  String content;
  String location;
  String address;
  String detailAddress;
  DateTime date;
  double lat;
  double lng;
  String groupId;

  ModakbulByGroupId({
    required this.title,
    required this.content,
    required this.location,
    required this.address,
    required this.detailAddress,
    required this.date,
    required this.lat,
    required this.lng,
    required this.groupId,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'location': location,
      'address': address,
      'detailAddress': detailAddress,
      'date': date.toIso8601String(),
      'lat': lat,
      'lng': lng,
      'groupId': groupId,
    };
  }

  @override
  String toString() {
    return 'ModakbulByGroup(title: $title, content: $content, location: $location, address: $address, detailAddress: $detailAddress, date: $date, lat: $lat, lng: $lng, groupId: $groupId)';
  }
}
