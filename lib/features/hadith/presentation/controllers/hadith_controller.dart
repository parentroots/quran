import 'package:get/get.dart';
import '../../data/services/hadith_api_service.dart';
import '../../../../core/services/storage_service.dart';
import 'dart:convert';

class HadithController extends GetxController {
  final HadithApiService _apiService = HadithApiService();
  final StorageService _storageService = Get.find<StorageService>();
  
  final RxList<Map<String, dynamic>> hadithBooks = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> hadiths = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingHadith = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString selectedBookId = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadHadithBooks();
  }
  
  // Load hadith books
  Future<void> loadHadithBooks() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final books = await _apiService.getHadithBooks();
      hadithBooks.value = books;
      
    } catch (e) {
      errorMessage.value = 'Error loading Hadith books: $e';
      print(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
  
  // Load hadiths from a specific book
  Future<void> loadHadithsFromBook(String bookId) async {
    try {
      isLoadingHadith.value = true;
      errorMessage.value = '';
      selectedBookId.value = bookId;
      
      // Check cache first
      final cacheKey = 'hadith_$bookId';
      if (_storageService.hasHadithCache(cacheKey)) {
        final cachedData = _storageService.getHadithCache(cacheKey);
        final List<dynamic> hadithsList = json.decode(cachedData);
        hadiths.value = hadithsList.cast<Map<String, dynamic>>();
        isLoadingHadith.value = false;
        return;
      }
      
      // Fetch from API
      final fetchedHadiths = await _apiService.getHadithsFromBook(bookId, 10);
      hadiths.value = fetchedHadiths;
      
      // Cache the data
      await _storageService.cacheHadithData(
        cacheKey,
        json.encode(fetchedHadiths),
      );
      
    } catch (e) {
      errorMessage.value = 'Error loading Hadiths: $e';
      print(errorMessage.value);
    } finally {
      isLoadingHadith.value = false;
    }
  }
  
  // Get a random hadith
  Future<Map<String, dynamic>?> getRandomHadith(String bookId) async {
    try {
      final hadith = await _apiService.getRandomHadith(bookId);
      return hadith;
    } catch (e) {
      errorMessage.value = 'Error loading Hadith: $e';
      print(errorMessage.value);
      return null;
    }
  }
}
