import 'package:get/get.dart';
import '../core/storage/local_storage.dart';
import '../services/data_service.dart';
import '../services/tts_service.dart';
import '../core/models/quran_model.dart';

class QuranController extends GetxController {
  final LocalStorage _storageService = Get.find();
  final DataService _apiService = Get.find<DataService>();
  final TtsService _ttsService = Get.find();

  final RxList<Surah> surahs = <Surah>[].obs;
  final RxList<Ayah> currentAyahs = <Ayah>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingAyahs = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<Surah?> currentSurah = Rx<Surah?>(null);

  final RxBool isPlaying = false.obs;
  final RxInt playingAyahNumber = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    _initTts();
    loadSurahs();
  }

  void _initTts() {
    _ttsService.setHandlers(
      onStart: () {
        isPlaying.value = true;
      },
      onComplete: () {
        isPlaying.value = false;
        playingAyahNumber.value = -1;
      },
      onError: (msg) {
        isPlaying.value = false;
        playingAyahNumber.value = -1;
        Get.snackbar('Recitation Error', 'Could not play audio: $msg');
      },
    );
  }

  Future<void> speakAyah(Ayah ayah) async {
    if (isPlaying.value && playingAyahNumber.value == ayah.numberInSurah) {
      await stopSpeaking();
      return;
    }

    await stopSpeaking();
    playingAyahNumber.value = ayah.numberInSurah;
    isPlaying.value = true;

    await _ttsService.speak(ayah.text);
  }

  Future<void> stopSpeaking() async {
    await _ttsService.stop();
    isPlaying.value = false;
    playingAyahNumber.value = -1;
  }

  @override
  void onClose() {
    _ttsService.stop();
    super.onClose();
  }

  Future<void> loadSurahs() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Check if data exists in cache
      if (_storageService.hasQuranData()) {
        surahs.value = _storageService.getSurahs();
        isLoading.value = false;
        return;
      }

      // Fetch from API
      await fetchAndCacheQuranData();
    } catch (e) {
      errorMessage.value = 'কুরআন লোড করতে সমস্যা হয়েছে: ${e.toString()}';
      // log error
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAndCacheQuranData() async {
    try {
      // This will take time, show a proper loading message
      Get.snackbar(
        'অনুগ্রহ করে অপেক্ষা করুন',
        'কুরআন ডাউনলোড হচ্ছে...',
        duration: const Duration(seconds: 5),
      );

      // Fetch all surahs first
      final fetchedSurahs = await _apiService.fetchAllSurahs();
      await _storageService.saveSurahs(fetchedSurahs);
      surahs.value = fetchedSurahs;

      // Fetch ayahs for each surah
      for (var surah in fetchedSurahs) {
        final ayahs = await _apiService.fetchSurahAyahs(surah.number);
        await _storageService.saveAyahs(surah.number, ayahs);
      }

      Get.snackbar(
        'সফল',
        'কুরআন সফলভাবে ডাউনলোড হয়েছে',
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'ত্রুটি',
        'কুরআন ডাউনলোড করতে ব্যর্থ: ${e.toString()}',
      );
      rethrow;
    }
  }

  Future<void> loadSurahAyahs(Surah surah) async {
    try {
      isLoadingAyahs.value = true;
      currentSurah.value = surah;

      // Load from cache
      currentAyahs.value = _storageService.getAyahs(surah.number);

      // If no ayahs in cache, fetch from API
      if (currentAyahs.isEmpty) {
        final ayahs = await _apiService.fetchSurahAyahs(surah.number);
        await _storageService.saveAyahs(surah.number, ayahs);
        currentAyahs.value = ayahs;
      }
    } catch (e) {
      errorMessage.value = 'আয়াত লোড করতে সমস্যা হয়েছে: ${e.toString()}';
      // log error
    } finally {
      isLoadingAyahs.value = false;
    }
  }

  void saveLastRead(int ayahNumber) {
    if (currentSurah.value != null) {
      final lastRead = LastRead(
        surahNumber: currentSurah.value!.number,
        ayahNumber: ayahNumber,
        surahName: currentSurah.value!.name,
        timestamp: DateTime.now(),
      );
      _storageService.saveLastRead(lastRead);
    }
  }

  Future<void> refreshQuranData() async {
    await fetchAndCacheQuranData();
  }
}
