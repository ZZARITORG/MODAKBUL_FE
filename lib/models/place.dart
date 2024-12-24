class Place {
  final String addressName;
  final String categoryGroupCode;
  final String categoryGroupName;
  final String categoryName;
  final int distance;
  final String id;
  final String phone;
  final String placeName;
  final String placeUrl;
  final String roadAddressName;
  final double x;
  final double y;

  Place({
    required this.addressName,
    required this.categoryGroupCode,
    required this.categoryGroupName,
    required this.categoryName,
    required this.distance,
    required this.id,
    required this.phone,
    required this.placeName,
    required this.placeUrl,
    required this.roadAddressName,
    required this.x,
    required this.y,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      addressName: json['address_name'] as String,
      categoryGroupCode: json['category_group_code'] as String,
      categoryGroupName: json['category_group_name'] as String,
      categoryName: json['category_name'] as String,
      distance: int.parse(json['distance'].toString()),
      id: json['id'] as String,
      phone: json['phone'] as String,
      placeName: json['place_name'] as String,
      placeUrl: json['place_url'] as String,
      roadAddressName: json['road_address_name'] as String,
      x: double.parse(json['x'].toString()),
      y: double.parse(json['y'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address_name': addressName,
      'category_group_code': categoryGroupCode,
      'category_group_name': categoryGroupName,
      'category_name': categoryName,
      'distance': distance,
      'id': id,
      'phone': phone,
      'place_name': placeName,
      'place_url': placeUrl,
      'road_address_name': roadAddressName,
      'x': x,
      'y': y,
    };
  }

  @override
  String toString() {
    return 'Place('
        'addressName: $addressName, '
        'categoryGroupCode: $categoryGroupCode, '
        'categoryGroupName: $categoryGroupName, '
        'categoryName: $categoryName, '
        'distance: $distance, '
        'id: $id, '
        'phone: $phone, '
        'placeName: $placeName, '
        'placeUrl: $placeUrl, '
        'roadAddressName: $roadAddressName, '
        'x: $x, '
        'y: $y'
        ')';
  }
}
