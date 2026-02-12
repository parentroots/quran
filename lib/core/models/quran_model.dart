import 'package:hive/hive.dart';

part 'quran_model.g.dart';

@HiveType(typeId: 0)
class Surah {
  @HiveField(0)
  final int number;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String englishName;
  
  @HiveField(3)
  final String englishNameTranslation;
  
  @HiveField(4)
  final int numberOfAyahs;
  
  @HiveField(5)
  final String revelationType;

  Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.numberOfAyahs,
    required this.revelationType,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['number'] ?? 0,
      name: json['name'] ?? '',
      englishName: json['englishName'] ?? '',
      englishNameTranslation: json['englishNameTranslation'] ?? '',
      numberOfAyahs: json['numberOfAyahs'] ?? 0,
      revelationType: json['revelationType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
      'englishName': englishName,
      'englishNameTranslation': englishNameTranslation,
      'numberOfAyahs': numberOfAyahs,
      'revelationType': revelationType,
    };
  }
}

@HiveType(typeId: 1)
class Ayah {
  @HiveField(0)
  final int number;
  
  @HiveField(1)
  final String text;
  
  @HiveField(2)
  final int numberInSurah;
  
  @HiveField(3)
  final int juz;
  
  @HiveField(4)
  final int manzil;
  
  @HiveField(5)
  final int page;
  
  @HiveField(6)
  final int ruku;
  
  @HiveField(7)
  final int hizbQuarter;
  
  @HiveField(8)
  final int sajda;
  
  @HiveField(9)
  final String? translation;

  Ayah({
    required this.number,
    required this.text,
    required this.numberInSurah,
    required this.juz,
    required this.manzil,
    required this.page,
    required this.ruku,
    required this.hizbQuarter,
    required this.sajda,
    this.translation,
  });

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      number: json['number'] ?? 0,
      text: json['text'] ?? '',
      numberInSurah: json['numberInSurah'] ?? 0,
      juz: json['juz'] ?? 0,
      manzil: json['manzil'] ?? 0,
      page: json['page'] ?? 0,
      ruku: json['ruku'] ?? 0,
      hizbQuarter: json['hizbQuarter'] ?? 0,
      sajda: json['sajda'] is bool 
          ? (json['sajda'] ? 1 : 0) 
          : (json['sajda'] ?? 0),
      translation: json['translation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'text': text,
      'numberInSurah': numberInSurah,
      'juz': juz,
      'manzil': manzil,
      'page': page,
      'ruku': ruku,
      'hizbQuarter': hizbQuarter,
      'sajda': sajda,
      'translation': translation,
    };
  }
}

class LastRead {
  final int surahNumber;
  final int ayahNumber;
  final String surahName;
  final DateTime timestamp;

  LastRead({
    required this.surahNumber,
    required this.ayahNumber,
    required this.surahName,
    required this.timestamp,
  });

  factory LastRead.fromJson(Map<String, dynamic> json) {
    return LastRead(
      surahNumber: json['surahNumber'] ?? 1,
      ayahNumber: json['ayahNumber'] ?? 1,
      surahName: json['surahName'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'surahNumber': surahNumber,
      'ayahNumber': ayahNumber,
      'surahName': surahName,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
