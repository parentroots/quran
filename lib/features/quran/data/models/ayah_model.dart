class AyahModel {
  final int number;
  final int numberInSurah;
  final String arabic;
  final String bangla;
  final String english;
  
  AyahModel({
    required this.number,
    required this.numberInSurah,
    required this.arabic,
    required this.bangla,
    required this.english,
  });
  
  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      number: json['number'],
      numberInSurah: json['numberInSurah'],
      arabic: json['arabic'] ?? '',
      bangla: json['bangla'] ?? '',
      english: json['english'] ?? '',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'numberInSurah': numberInSurah,
      'arabic': arabic,
      'bangla': bangla,
      'english': english,
    };
  }
}
