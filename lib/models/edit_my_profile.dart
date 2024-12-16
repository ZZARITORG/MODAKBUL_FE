class EditMyProfile {
  final String userId;
  final String phoneNo;
  final String name;
  final String profileUrl;

  EditMyProfile({
    required this.userId,
    required this.phoneNo,
    required this.name,
    required this.profileUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'phoneNo': phoneNo,
      'name': name,
      'profileUrl': profileUrl,
    };
  }
}