import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/surah_model.dart';
import '../models/ayah_model.dart';

class QuranApiService {
  // Using Al-Quran Cloud API
  static const String baseUrl = 'https://api.alquran.cloud/v1';
  
  // Get all Surahs list
  Future<List<SurahModel>> getAllSurahs() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/surah'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List surahs = data['data'];
        return surahs.map((surah) => SurahModel.fromJson(surah)).toList();
      } else {
        throw Exception('Failed to load surahs');
      }
    } catch (e) {
      throw Exception('Error fetching surahs: $e');
    }
  }
  
  // Get specific Surah with Arabic text
  Future<Map<String, dynamic>> getSurahArabic(int surahNumber) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/surah/$surahNumber'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to load surah');
      }
    } catch (e) {
      throw Exception('Error fetching surah: $e');
    }
  }
  
  // Get Surah with Bangla translation
  Future<Map<String, dynamic>> getSurahBangla(int surahNumber) async {
    try {
      // Using edition bn.bengali for Bangla translation
      final response = await http.get(
        Uri.parse('$baseUrl/surah/$surahNumber/bn.bengali'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to load bangla translation');
      }
    } catch (e) {
      throw Exception('Error fetching bangla translation: $e');
    }
  }
  
  // Get Surah with English translation
  Future<Map<String, dynamic>> getSurahEnglish(int surahNumber) async {
    try {
      // Using edition en.sahih for English translation
      final response = await http.get(
        Uri.parse('$baseUrl/surah/$surahNumber/en.sahih'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to load english translation');
      }
    } catch (e) {
      throw Exception('Error fetching english translation: $e');
    }
  }
  
  // Get combined Surah data (Arabic + Bangla + English)
  Future<Map<String, dynamic>> getSurahComplete(int surahNumber) async {
    try {
      final arabicData = await getSurahArabic(surahNumber);
      final banglaData = await getSurahBangla(surahNumber);
      final englishData = await getSurahEnglish(surahNumber);
      
      // Combine ayahs
      List<Map<String, dynamic>> combinedAyahs = [];
      
      for (int i = 0; i < arabicData['ayahs'].length; i++) {
        combinedAyahs.add({
          'number': arabicData['ayahs'][i]['number'],
          'numberInSurah': arabicData['ayahs'][i]['numberInSurah'],
          'arabic': arabicData['ayahs'][i]['text'],
          'bangla': banglaData['ayahs'][i]['text'],
          'english': englishData['ayahs'][i]['text'],
        });
      }
      
      return {
        'number': arabicData['number'],
        'name': arabicData['name'],
        'englishName': arabicData['englishName'],
        'englishNameTranslation': arabicData['englishNameTranslation'],
        'numberOfAyahs': arabicData['numberOfAyahs'],
        'revelationType': arabicData['revelationType'],
        'ayahs': combinedAyahs,
      };
    } catch (e) {
      throw Exception('Error fetching complete surah: $e');
    }
  }
}
