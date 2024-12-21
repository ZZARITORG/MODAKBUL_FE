class EditMyProfile {
  final String? userId;
  final String? phoneNo;
  final String? name;
  final String? profileUrl;

  EditMyProfile({
    this.userId,
    this.phoneNo,
    this.name,
    this.profileUrl,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (userId != null) data['userId'] = userId;
    if (phoneNo != null) data['phoneNo'] = phoneNo;
    if (name != null) data['name'] = name;
    if (profileUrl != null) data['profileUrl'] = profileUrl;
    return data;
  }
}