class EditMyProfile {
  final String? userId;
  final String? phoneNo;
  final String? name;
  final String? profileUrl;
  final bool? isContactAgree;
  final bool? isFriendAlarm;

  EditMyProfile({
    this.userId,
    this.phoneNo,
    this.name,
    this.profileUrl,
    this.isContactAgree,
    this.isFriendAlarm
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (userId != null) data['userId'] = userId;
    if (phoneNo != null) data['phoneNo'] = phoneNo;
    if (name != null) data['name'] = name;
    if (profileUrl != null) data['profileUrl'] = profileUrl;
    if (isContactAgree != null) data['isContactAgree'] = isContactAgree;
    if (isFriendAlarm != null) data['isFriendAlarm'] = isFriendAlarm;
    return data;
  }
}