class PhoneNumber {
  final String phoneNumber;

  PhoneNumber({required this.phoneNumber});

  Map<String, dynamic> toJson() {
    return {
      'phoneNo': phoneNumber,
    };
  }
}