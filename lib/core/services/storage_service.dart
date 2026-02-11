import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;
  late Box _settingsBox;
  late Box _quranBox;
  late Box _hadithBox;
  
  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    
    // Initialize Hive boxes
    _settingsBox = await Hive.openBox('settings');
    _quranBox = await Hive.openBox('quran_cache');
    _hadithBox = await Hive.openBox('hadith_cache');
    
    return this;
  }
  
  // Dark Mode
  bool get isDarkMode => _settingsBox.get('isDarkMode', defaultValue: false);
  Future<void> setDarkMode(bool value) async {
    await _settingsBox.put('isDarkMode', value);
  }
  
  // Last Read Surah
  int get lastReadSurah => _settingsBox.get('lastReadSurah', defaultValue: 1);
  Future<void> setLastReadSurah(int value) async {
    await _settingsBox.put('lastReadSurah', value);
  }
  
  // Last Read Ayah
  int get lastReadAyah => _settingsBox.get('lastReadAyah', defaultValue: 1);
  Future<void> setLastReadAyah(int value) async {
    await _settingsBox.put('lastReadAyah', value);
  }
  
  // Quran Data Cache
  Future<void> cacheQuranData(String key, dynamic data) async {
    await _quranBox.put(key, data);
  }
  
  dynamic getQuranCache(String key) {
    return _quranBox.get(key);
  }
  
  bool hasQuranCache(String key) {
    return _quranBox.containsKey(key);
  }
  
  // Hadith Data Cache
  Future<void> cacheHadithData(String key, dynamic data) async {
    await _hadithBox.put(key, data);
  }
  
  dynamic getHadithCache(String key) {
    return _hadithBox.get(key);
  }
  
  bool hasHadithCache(String key) {
    return _hadithBox.containsKey(key);
  }
  
  // Prayer Alarm Settings
  bool isPrayerAlarmEnabled(String prayer) {
    return _settingsBox.get('alarm_$prayer', defaultValue: true);
  }
  
  Future<void> setPrayerAlarmEnabled(String prayer, bool value) async {
    await _settingsBox.put('alarm_$prayer', value);
  }
  
  // Clear all cache
  Future<void> clearAllCache() async {
    await _quranBox.clear();
    await _hadithBox.clear();
  }
}
