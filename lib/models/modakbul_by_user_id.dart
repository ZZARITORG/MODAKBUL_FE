class ModakbulByUserId {
  String title;
  String content;
  String location;
  String address;
  String detailAddress;
  DateTime date;
  double lat;
  double lng;
  List<String> friendIds;

  ModakbulByUserId({
    required this.title,
    required this.content,
    required this.location,
    required this.address,
    required this.detailAddress,
    required this.date,
    required this.lat,
    required this.lng,
    required this.friendIds,
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
      'friendIds': friendIds,
    };
  }

  @override
  String toString() {
    return 'ModakbulByUserId{title: $title, content: $content, location: $location, address: $address, detailAddress: $detailAddress, date: $date, lat: $lat, lng: $lng, friendIds: $friendIds}';
  }
}
