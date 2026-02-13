import 'package:hive/hive.dart';

part 'hadith_model.g.dart';

@HiveType(typeId: 2)
class HadithBook {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String writerName;
  
  @HiveField(3)
  final int numberOfHadith;

  HadithBook({
    required this.id,
    required this.name,
    required this.writerName,
    required this.numberOfHadith,
  });

  factory HadithBook.fromJson(Map<String, dynamic> json) {
    return HadithBook(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      writerName: json['writerName'] ?? '',
      numberOfHadith: json['numberOfHadith'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'writerName': writerName,
      'numberOfHadith': numberOfHadith,
    };
  }
}

@HiveType(typeId: 3)
class Hadith {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String bookId;
  
  @HiveField(2)
  final int hadithNumber;
  
  @HiveField(3)
  final String text;
  
  @HiveField(4)
  final String narrator;
  
  @HiveField(5)
  final String? category;

  Hadith({
    required this.id,
    required this.bookId,
    required this.hadithNumber,
    required this.text,
    required this.narrator,
    this.category,
  });

  factory Hadith.fromJson(Map<String, dynamic> json) {
    return Hadith(
      id: json['id'] ?? '',
      bookId: json['bookId'] ?? '',
      hadithNumber: json['hadithNumber'] ?? 0,
      text: json['text'] ?? '',
      narrator: json['narrator'] ?? '',
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'hadithNumber': hadithNumber,
      'text': text,
      'narrator': narrator,
      'category': category,
    };
  }
}
