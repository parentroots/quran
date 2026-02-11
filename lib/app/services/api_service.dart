import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import '../data/models/quran_model.dart';
import '../data/models/hadith_model.dart';

class ApiService extends getx.GetxService {
  late final Dio _dio;

  // API URLs
  static const String quranApiBase = 'https://api.alquran.cloud/v1';
  static const String hadithApiBase = 'https://hadithapi.com/api';

  Future<ApiService> init() async {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    return this;
  }

  // Fetch all Surahs
  Future<List<Surah>> fetchAllSurahs() async {
    try {
      final response = await _dio.get('$quranApiBase/surah');
      
      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((json) => Surah.fromJson(json)).toList();
      }
      throw Exception('Failed to fetch surahs');
    } catch (e) {
      print('Error fetching surahs: $e');
      rethrow;
    }
  }

  // Fetch Ayahs of a Surah with Arabic text
  Future<List<Ayah>> fetchSurahAyahs(int surahNumber) async {
    try {
      // Fetch Arabic text
      final arabicResponse = await _dio.get(
        '$quranApiBase/surah/$surahNumber',
      );

      // Fetch Bengali translation
      final bengaliResponse = await _dio.get(
        '$quranApiBase/surah/$surahNumber/bn.bengali',
      );

      if (arabicResponse.statusCode == 200 && bengaliResponse.statusCode == 200) {
        final arabicAyahs = arabicResponse.data['data']['ayahs'] as List;
        final bengaliAyahs = bengaliResponse.data['data']['ayahs'] as List;

        List<Ayah> ayahs = [];
        for (int i = 0; i < arabicAyahs.length; i++) {
          final arabicData = arabicAyahs[i];
          final bengaliData = bengaliAyahs[i];

          ayahs.add(Ayah(
            number: arabicData['number'],
            text: arabicData['text'],
            numberInSurah: arabicData['numberInSurah'],
            juz: arabicData['juz'],
            manzil: arabicData['manzil'],
            page: arabicData['page'],
            ruku: arabicData['ruku'],
            hizbQuarter: arabicData['hizbQuarter'],
            sajda: arabicData['sajda'] is bool 
                ? (arabicData['sajda'] ? 1 : 0) 
                : 0,
            translation: bengaliData['text'],
          ));
        }
        return ayahs;
      }
      throw Exception('Failed to fetch ayahs');
    } catch (e) {
      print('Error fetching ayahs: $e');
      rethrow;
    }
  }

  // Fetch all Quran data (for initial load)
  Future<Map<String, dynamic>> fetchAllQuranData() async {
    try {
      final surahs = await fetchAllSurahs();
      final Map<int, List<Ayah>> allAyahs = {};

      // Fetch ayahs for each surah
      for (var surah in surahs) {
        final ayahs = await fetchSurahAyahs(surah.number);
        allAyahs[surah.number] = ayahs;
        
        // Add a small delay to avoid overwhelming the API
        await Future.delayed(const Duration(milliseconds: 200));
      }

      return {
        'surahs': surahs,
        'ayahs': allAyahs,
      };
    } catch (e) {
      print('Error fetching all Quran data: $e');
      rethrow;
    }
  }

  // Fetch Hadith Books (Mock data since we need Bangla Hadith)
  Future<List<HadithBook>> fetchHadithBooks() async {
    // Mock Hadith books data in Bangla
    return [
      HadithBook(
        id: 'bukhari',
        name: 'সহীহ বুখারী',
        writerName: 'ইমাম বুখারী',
        numberOfHadith: 7563,
      ),
      HadithBook(
        id: 'muslim',
        name: 'সহীহ মুসলিম',
        writerName: 'ইমাম মুসলিম',
        numberOfHadith: 7190,
      ),
      HadithBook(
        id: 'abudawud',
        name: 'সুনান আবু দাউদ',
        writerName: 'ইমাম আবু দাউদ',
        numberOfHadith: 5274,
      ),
      HadithBook(
        id: 'tirmidhi',
        name: 'জামে তিরমিযী',
        writerName: 'ইমাম তিরমিযী',
        numberOfHadith: 3956,
      ),
      HadithBook(
        id: 'nasai',
        name: 'সুনান নাসাঈ',
        writerName: 'ইমাম নাসাঈ',
        numberOfHadith: 5758,
      ),
      HadithBook(
        id: 'ibnmajah',
        name: 'সুনান ইবনে মাজাহ',
        writerName: 'ইমাম ইবনে মাজাহ',
        numberOfHadith: 4341,
      ),
    ];
  }

  // Fetch Hadiths from a specific book (Mock data)
  Future<List<Hadith>> fetchHadiths(String bookId) async {
    // Mock Hadith data - In a real app, this would come from an API
    final mockHadiths = <Hadith>[];
    
    for (int i = 1; i <= 20; i++) {
      mockHadiths.add(Hadith(
        id: '${bookId}_$i',
        bookId: bookId,
        hadithNumber: i,
        text: _getMockHadithText(bookId, i),
        narrator: _getMockNarrator(i),
        category: _getMockCategory(i),
      ));
    }
    
    return mockHadiths;
  }

  String _getMockHadithText(String bookId, int number) {
    final texts = [
      'আল্লাহর রাসূল (সা.) বলেছেন: "মুসলমান সেই, যার মুখ ও হাত থেকে অন্য মুসলমানগণ নিরাপদ থাকে।"',
      'নবী করীম (সা.) বলেন: "নিশ্চয়ই সকল আমল নিয়তের উপর নির্ভরশীল এবং প্রত্যেক ব্যক্তি তার নিয়ত অনুযায়ী ফল পাবে।"',
      'রাসূলুল্লাহ (সা.) বলেছেন: "মায়ের পায়ের নিচে সন্তানের জান্নাত।"',
      'নবীজি (সা.) বলেন: "উত্তম মুসলমান সেই ব্যক্তি যে অন্যের জন্য তাই পছন্দ করে যা নিজের জন্য পছন্দ করে।"',
      'আল্লাহর রাসূল (সা.) বলেছেন: "জ্ঞান অর্জন করা প্রত্যেক মুসলিম নর-নারীর উপর ফরজ।"',
      'নবী করীম (সা.) বলেন: "যে ব্যক্তি মানুষকে ধন্যবাদ জানায় না, সে আল্লাহকেও ধন্যবাদ জানায় না।"',
      'রাসূলুল্লাহ (সা.) বলেছেন: "আল্লাহর নিকট সবচেয়ে প্রিয় আমল হলো নিয়মিত আমল, যদিও তা অল্প হয়।"',
      'নবীজি (সা.) বলেন: "হাসিমুখে তোমার ভাইয়ের সাথে সাক্ষাৎ করাও একটি সদকা।"',
      'আল্লাহর রাসূল (সা.) বলেছেন: "প্রকৃত বীর সেই নয় যে কুস্তিতে জয়ী হয়, বরং প্রকৃত বীর সেই যে রাগের সময় নিজেকে নিয়ন্ত্রণ করতে পারে।"',
      'নবী করীম (সা.) বলেন: "যে ব্যক্তি কোনো অসুবিধায় পতিত মুসলমানের অসুবিধা দূর করবে, আল্লাহ তার দুনিয়া ও আখিরাতের অসুবিধা দূর করবেন।"',
    ];
    
    return texts[number % texts.length];
  }

  String _getMockNarrator(int number) {
    final narrators = [
      'আবু হুরায়রা (রা.)',
      'আয়েশা (রা.)',
      'আবদুল্লাহ ইবনে উমর (রা.)',
      'আনাস ইবনে মালিক (রা.)',
      'আবদুল্লাহ ইবনে মাসউদ (রা.)',
    ];
    return narrators[number % narrators.length];
  }

  String _getMockCategory(int number) {
    final categories = [
      'ঈমান',
      'ইবাদত',
      'আখলাক',
      'সামাজিক',
      'জ্ঞান',
    ];
    return categories[number % categories.length];
  }
}
