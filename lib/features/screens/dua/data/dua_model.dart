class Dua {
  final String id;
  final String category;
  final String title;
  final String arabic;
  final String translation;
  final String transliteration;
  final String reference;

  Dua({
    required this.id,
    required this.category,
    required this.title,
    required this.arabic,
    required this.translation,
    required this.transliteration,
    required this.reference,
  });

  factory Dua.fromJson(Map<String, dynamic> json) {
    return Dua(
      id: json['id'],
      category: json['category'],
      title: json['title'],
      arabic: json['arabic'],
      translation: json['translation'],
      transliteration: json['transliteration'],
      reference: json['reference'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'title': title,
      'arabic': arabic,
      'translation': translation,
      'transliteration': transliteration,
      'reference': reference,
    };
  }
}

class DuaCategory {
  final String name;
  final String icon;

  DuaCategory({required this.name, required this.icon});
}
