import 'package:get/get.dart';
import '../../../services/storage_service.dart';
import '../../../services/api_service.dart';
import '../../../data/models/hadith_model.dart';

class HadithController extends GetxController {
  final StorageService _storageService = Get.find();
  final ApiService _apiService = Get.find<ApiService>();

  final RxList<HadithBook> books = <HadithBook>[].obs;
  final RxList<Hadith> currentHadiths = <Hadith>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingHadiths = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<HadithBook?> currentBook = Rx<HadithBook?>(null);

  @override
  void onInit() {
    super.onInit();
    loadHadithBooks();
  }

  Future<void> loadHadithBooks() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Check if data exists in cache
      if (_storageService.hasHadithData()) {
        books.value = _storageService.getHadithBooks();
        isLoading.value = false;
        return;
      }

      // Fetch from API
      final fetchedBooks = await _apiService.fetchHadithBooks();
      await _storageService.saveHadithBooks(fetchedBooks);
      books.value = fetchedBooks;

      // Cache some hadiths for offline use
      for (var book in fetchedBooks) {
        final hadiths = await _apiService.fetchHadiths(book.id);
        await _storageService.saveHadiths(book.id, hadiths);
      }
    } catch (e) {
      errorMessage.value = 'হাদিস লোড করতে সমস্যা হয়েছে: ${e.toString()}';
      print('Error loading hadith books: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadHadiths(HadithBook book) async {
    try {
      isLoadingHadiths.value = true;
      currentBook.value = book;

      // Load from cache first
      var hadiths = _storageService.getHadiths(book.id);
      
      // If no hadiths in cache, fetch from API
      if (hadiths.isEmpty) {
        hadiths = await _apiService.fetchHadiths(book.id);
        await _storageService.saveHadiths(book.id, hadiths);
      }
      
      currentHadiths.value = hadiths;
    } catch (e) {
      errorMessage.value = 'হাদিস লোড করতে সমস্যা হয়েছে: ${e.toString()}';
      print('Error loading hadiths: $e');
    } finally {
      isLoadingHadiths.value = false;
    }
  }

  Future<void> refreshHadithData() async {
    await loadHadithBooks();
  }
}
