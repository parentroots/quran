import 'package:get/get.dart';
import '../../data/models/surah_model.dart';
import '../../data/models/ayah_model.dart';
import '../../data/services/quran_api_service.dart';
import '../../../../core/services/storage_service.dart';
import 'dart:convert';

class QuranController extends GetxController {
  final QuranApiService _apiService = QuranApiService();
  final StorageService _storageService = Get.find<StorageService>();
  
  final RxList<SurahModel> surahs = <SurahModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingSurah = false.obs;
  final RxString errorMessage = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadSurahs();
  }
  
  // Load all surahs
  Future<void> loadSurahs() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // Check cache first
      if (_storageService.hasQuranCache('surahs_list')) {
        final cachedData = _storageService.getQuranCache('surahs_list');
        final List<dynamic> surahsList = json.decode(cachedData);
        surahs.value = surahsList.map((s) => SurahModel.fromJson(s)).toList();
        isLoading.value = false;
        return;
      }
      
      // Fetch from API
      final fetchedSurahs = await _apiService.getAllSurahs();
      surahs.value = fetchedSurahs;
      
      // Cache the data
      final surahsJson = json.encode(
        fetchedSurahs.map((s) => s.toJson()).toList(),
      );
      await _storageService.cacheQuranData('surahs_list', surahsJson);
      
    } catch (e) {
      errorMessage.value = 'Error loading Surahs: $e';
      print(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
  
  // Get Surah details with ayahs
  Future<Map<String, dynamic>?> getSurahDetail(int surahNumber) async {
    try {
      isLoadingSurah.value = true;
      errorMessage.value = '';
      
      // Check cache first
      final cacheKey = 'surah_$surahNumber';
      if (_storageService.hasQuranCache(cacheKey)) {
        final cachedData = _storageService.getQuranCache(cacheKey);
        return json.decode(cachedData);
      }
      
      // Fetch from API
      final surahData = await _apiService.getSurahComplete(surahNumber);
      
      // Cache the data
      await _storageService.cacheQuranData(
        cacheKey,
        json.encode(surahData),
      );
      
      return surahData;
      
    } catch (e) {
      errorMessage.value = 'Error loading Surah details: $e';
      print(errorMessage.value);
      return null;
    } finally {
      isLoadingSurah.value = false;
    }
  }
  
  // Save last read position
  Future<void> saveLastRead(int surahNumber, int ayahNumber) async {
    await _storageService.setLastReadSurah(surahNumber);
    await _storageService.setLastReadAyah(ayahNumber);
  }
  
  // Get last read position
  Map<String, int> getLastRead() {
    return {
      'surah': _storageService.lastReadSurah,
      'ayah': _storageService.lastReadAyah,
    };
  }
}
