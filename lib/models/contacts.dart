class Contacts {
  final List<String> contacts;

  Contacts({required this.contacts});

  factory Contacts.fromJson(Map<String, dynamic> json) {
    return Contacts(
      contacts: List<String>.from(json['contacts'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contacts': contacts,
    };
  }
}