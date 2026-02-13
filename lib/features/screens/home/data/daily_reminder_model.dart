class ReminderModel {
  final String title;
  final String reference;

  ReminderModel({
    required this.title,
    required this.reference,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      title: json['title'] ?? '',
      reference: json['reference'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'reference': reference,
    };
  }
}
