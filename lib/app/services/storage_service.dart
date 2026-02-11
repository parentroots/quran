import 'dart:convert';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/quran_model.dart';
import '../data/models/hadith_model.dart';
import '../data/models/tasbeeh_history_model.dart';

class StorageService extends GetxService {
  late final SharedPreferences _prefs;
  late final Box _settingsBox;
  late final Box<Surah> _surahBox;
  late final Box<Ayah> _ayahBox;
  late final Box<HadithBook> _hadithBookBox;
  late final Box<Hadith> _hadithBox;
  late final Box<TasbeehHistory> _tasbeehHistoryBox;

  Future<StorageService> init() async {
    // Initialize SharedPreferences
    _prefs = await SharedPreferences.getInstance();

    // Register Hive Adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(SurahAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(AyahAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(HadithBookAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(HadithAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(TasbeehHistoryAdapter());
    }

    // Open Hive Boxes
    _settingsBox = await Hive.openBox('settings');
    _surahBox = await Hive.openBox<Surah>('surahs');
    _ayahBox = await Hive.openBox<Ayah>('ayahs');
    _hadithBookBox = await Hive.openBox<HadithBook>('hadith_books');
    _hadithBox = await Hive.openBox<Hadith>('hadiths');
    _tasbeehHistoryBox = await Hive.openBox<TasbeehHistory>('tasbeeh_history');

    return this;
  }

  // Quran Data Methods
  Future<void> saveSurahs(List<Surah> surahs) async {
    await _surahBox.clear();
    for (var surah in surahs) {
      await _surahBox.put(surah.number, surah);
    }
  }

  List<Surah> getSurahs() {
    return _surahBox.values.toList();
  }

  Surah? getSurah(int number) {
    return _surahBox.get(number);
  }

  Future<void> saveAyahs(int surahNumber, List<Ayah> ayahs) async {
    for (var ayah in ayahs) {
      await _ayahBox.put('${surahNumber}_${ayah.numberInSurah}', ayah);
    }
  }

  List<Ayah> getAyahs(int surahNumber) {
    final ayahs = <Ayah>[];
    for (var key in _ayahBox.keys) {
      if (key.toString().startsWith('${surahNumber}_')) {
        final ayah = _ayahBox.get(key);
        if (ayah != null) ayahs.add(ayah);
      }
    }
    ayahs.sort((a, b) => a.numberInSurah.compareTo(b.numberInSurah));
    return ayahs;
  }

  bool hasQuranData() {
    return _surahBox.isNotEmpty;
  }

  // Last Read Methods
  Future<void> saveLastRead(LastRead lastRead) async {
    await _prefs.setString('last_read', jsonEncode(lastRead.toJson()));
  }

  LastRead? getLastRead() {
    final data = _prefs.getString('last_read');
    if (data != null) {
      return LastRead.fromJson(jsonDecode(data));
    }
    return null;
  }

  // Hadith Data Methods
  Future<void> saveHadithBooks(List<HadithBook> books) async {
    await _hadithBookBox.clear();
    for (var book in books) {
      await _hadithBookBox.put(book.id, book);
    }
  }

  List<HadithBook> getHadithBooks() {
    return _hadithBookBox.values.toList();
  }

  Future<void> saveHadiths(String bookId, List<Hadith> hadiths) async {
    for (var hadith in hadiths) {
      await _hadithBox.put(hadith.id, hadith);
    }
  }

  List<Hadith> getHadiths(String bookId) {
    return _hadithBox.values.where((h) => h.bookId == bookId).toList();
  }

  bool hasHadithData() {
    return _hadithBookBox.isNotEmpty;
  }

  // Settings Methods
  Future<void> setDarkMode(bool value) async {
    await _settingsBox.put('dark_mode', value);
  }

  bool getDarkMode() {
    return _settingsBox.get('dark_mode', defaultValue: false);
  }

  Future<void> setArabicFontSize(double size) async {
    await _settingsBox.put('arabic_font_size', size);
  }

  double getArabicFontSize() {
    return _settingsBox.get('arabic_font_size', defaultValue: 28.0);
  }

  Future<void> setTranslationFontSize(double size) async {
    await _settingsBox.put('translation_font_size', size);
  }

  double getTranslationFontSize() {
    return _settingsBox.get('translation_font_size', defaultValue: 16.0);
  }

  // Prayer Alarm Methods
  Future<void> savePrayerAlarms(List<Map<String, dynamic>> alarms) async {
    await _prefs.setString('prayer_alarms', jsonEncode(alarms));
  }

  List<Map<String, dynamic>> getPrayerAlarms() {
    final data = _prefs.getString('prayer_alarms');
    if (data != null) {
      return List<Map<String, dynamic>>.from(jsonDecode(data));
    }
    return [];
  }

  // Location Methods
  Future<void> saveLocation(double latitude, double longitude) async {
    await _prefs.setDouble('latitude', latitude);
    await _prefs.setDouble('longitude', longitude);
  }

  Map<String, double>? getLocation() {
    final lat = _prefs.getDouble('latitude');
    final lng = _prefs.getDouble('longitude');
    if (lat != null && lng != null) {
      return {'latitude': lat, 'longitude': lng};
    }
    return null;
  }

  // Clear All Data
  Future<void> clearAllData() async {
    await _surahBox.clear();
    await _ayahBox.clear();
    await _hadithBookBox.clear();
    await _hadithBox.clear();
    await _tasbeehHistoryBox.clear();
    await _prefs.clear();
  }

  // Tasbeeh History Methods
  Future<void> saveTasbeehHistory(TasbeehHistory history) async {
    await _tasbeehHistoryBox.add(history);
  }

  List<TasbeehHistory> getTasbeehHistory() {
    return _tasbeehHistoryBox.values.toList().reversed.toList();
  }

  Future<void> deleteTasbeehHistory(int index) async {
    await _tasbeehHistoryBox.deleteAt(index);
  }

  Future<void> clearTasbeehHistory() async {
    await _tasbeehHistoryBox.clear();
  }
}
