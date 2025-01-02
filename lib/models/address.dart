class Address {
  final RoadAddress? roadAddress;
  final DetailedAddress detailedAddress;

  Address({required this.roadAddress, required this.detailedAddress});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      roadAddress: json['road_address'] != null
          ? RoadAddress.fromJson(json['road_address'])
          : null, // Handle null for road_address,
      detailedAddress: DetailedAddress.fromJson(json['address']),
    );
  }

  @override
  String toString() {
    return 'Address(roadAddress: $roadAddress, detailedAddress: $detailedAddress)';
  }
}


class RoadAddress {
  final String addressName;
  final String region1DepthName;
  final String region2DepthName;
  final String region3DepthName;
  final String roadName;
  final String undergroundYn;
  final String mainBuildingNo;
  final String subBuildingNo;
  final String buildingName;
  final String zoneNo;

  RoadAddress({
    required this.addressName,
    required this.region1DepthName,
    required this.region2DepthName,
    required this.region3DepthName,
    required this.roadName,
    required this.undergroundYn,
    required this.mainBuildingNo,
    required this.subBuildingNo,
    required this.buildingName,
    required this.zoneNo,
  });

  factory RoadAddress.fromJson(Map<String, dynamic> json) {
    return RoadAddress(
      addressName: json['address_name'],
      region1DepthName: json['region_1depth_name'],
      region2DepthName: json['region_2depth_name'],
      region3DepthName: json['region_3depth_name'],
      roadName: json['road_name'],
      undergroundYn: json['underground_yn'],
      mainBuildingNo: json['main_building_no'],
      subBuildingNo: json['sub_building_no'] ?? '',
      buildingName: json['building_name'],
      zoneNo: json['zone_no'],
    );
  }
}

class DetailedAddress {
  final String addressName;
  final String region1DepthName;
  final String region2DepthName;
  final String region3DepthName;
  final String mountainYn;
  final String mainAddressNo;
  final String subAddressNo;
  final String zipCode;

  DetailedAddress({
    required this.addressName,
    required this.region1DepthName,
    required this.region2DepthName,
    required this.region3DepthName,
    required this.mountainYn,
    required this.mainAddressNo,
    required this.subAddressNo,
    required this.zipCode,
  });

  factory DetailedAddress.fromJson(Map<String, dynamic> json) {
    return DetailedAddress(
      addressName: json['address_name'],
      region1DepthName: json['region_1depth_name'],
      region2DepthName: json['region_2depth_name'],
      region3DepthName: json['region_3depth_name'],
      mountainYn: json['mountain_yn'],
      mainAddressNo: json['main_address_no'],
      subAddressNo: json['sub_address_no'] ?? '',
      zipCode: json['zip_code'] ?? '',
    );
  }
}
