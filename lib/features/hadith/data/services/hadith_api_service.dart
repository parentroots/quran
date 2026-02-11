import 'dart:convert';
import 'package:http/http.dart' as http;

class HadithApiService {
  // Using Hadith API
  static const String baseUrl = 'https://random-hadith-generator.vercel.app';
  
  // Get Hadith collections
  Future<List<Map<String, dynamic>>> getHadithBooks() async {
    // Return list of available hadith books
    return [
      {
        'id': 'bukhari',
        'name': 'Sahih Bukhari',
        'nameArabic': 'صحيح البخاري',
        'totalHadith': 7563,
      },
      {
        'id': 'muslim',
        'name': 'Sahih Muslim',
        'nameArabic': 'صحيح مسلم',
        'totalHadith': 7190,
      },
      {
        'id': 'abudawud',
        'name': 'Sunan Abu Dawud',
        'nameArabic': 'سنن أبي داود',
        'totalHadith': 5274,
      },
      {
        'id': 'tirmidhi',
        'name': 'Jami At-Tirmidhi',
        'nameArabic': 'جامع الترمذي',
        'totalHadith': 3956,
      },
      {
        'id': 'nasai',
        'name': "Sunan An-Nasa'i",
        'nameArabic': 'سنن النسائي',
        'totalHadith': 5758,
      },
      {
        'id': 'ibnmajah',
        'name': 'Sunan Ibn Majah',
        'nameArabic': 'سنن ابن ماجه',
        'totalHadith': 4341,
      },
    ];
  }
  
  // Get random hadith from a book
  Future<Map<String, dynamic>> getRandomHadith(String bookId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$bookId'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'hadithNumber': data['data']['hadithNumber'] ?? '',
          'englishNarrator': data['data']['englishNarrator'] ?? '',
          'hadithEnglish': data['data']['hadithEnglish'] ?? '',
          'hadithArabic': data['data']['hadithArabic'] ?? '',
          'book': data['data']['book'] ?? {},
          'chapter': data['data']['chapter'] ?? {},
        };
      } else {
        throw Exception('Failed to load hadith');
      }
    } catch (e) {
      throw Exception('Error fetching hadith: $e');
    }
  }
  
  // Get multiple hadiths for a book (mock implementation)
  Future<List<Map<String, dynamic>>> getHadithsFromBook(
    String bookId,
    int count,
  ) async {
    List<Map<String, dynamic>> hadiths = [];
    
    for (int i = 0; i < count; i++) {
      try {
        final hadith = await getRandomHadith(bookId);
        hadiths.add(hadith);
        // Add small delay to avoid overwhelming the API
        await Future.delayed(const Duration(milliseconds: 500));
      } catch (e) {
        print('Error fetching hadith $i: $e');
      }
    }
    
    return hadiths;
  }
}
