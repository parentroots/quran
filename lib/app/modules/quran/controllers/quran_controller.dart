import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../services/storage_service.dart';
import '../../../services/api_service.dart';
import '../../../data/models/quran_model.dart';

class QuranController extends GetxController {
  final StorageService _storageService = Get.find();
  final ApiService _apiService = Get.find<ApiService>();
  final FlutterTts _flutterTts = FlutterTts();

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

  Future<void> _initTts() async {
    try {
      final languages = await _flutterTts.getLanguages;
      print('Available languages: $languages');

      // Check if Arabic (Saudi Arabia) is specifically available
      bool isArSaAvailable = await _flutterTts.isLanguageAvailable("ar-SA");
      print('Arabic (SA) available: $isArSaAvailable');

      await _flutterTts.setLanguage(isArSaAvailable ? 'ar-SA' : 'ar');
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(
          1.0); // Slightly lower pitch for more male-like sound if voice selection fails

      // Attempt to find and set a male voice
      final List<dynamic>? voices = await _flutterTts.getVoices;
      if (voices != null) {
        try {
          // Filter for Arabic voices, prioritizing Saudi Arabia for better quality
          final arVoices = voices
              .where((v) =>
                  v['locale'].toString().startsWith('ar-SA') ||
                  v['locale'].toString().startsWith('ar'))
              .toList();
          print('Found ${arVoices.length} Arabic voices');

          // Try to find a voice that likely sounds male
          // Patterns: 'male', 'man', 'low', 'standard-b' (google), '#male'
          var maleVoice = arVoices.firstWhere(
            (v) {
              final name = v['name'].toString().toLowerCase();
              return name.contains('male') ||
                  name.contains('man') ||
                  name.contains('low') ||
                  name.contains('b-') || // Google 'b' voices are often male
                  name.contains('d-'); // Google 'd' voices are often male
            },
            orElse: () => null,
          );

          if (maleVoice != null) {
            await _flutterTts.setVoice(
                {"name": maleVoice['name'], "locale": maleVoice['locale']});
            print('Selected male voice: ${maleVoice['name']}');
            await _flutterTts.setPitch(1.0); // Reset pitch if male voice found
          } else if (arVoices.isNotEmpty) {
            // Pick a default Arabic voice if no explicit male one is found
            // Often higher index voices in Google TTS are male
            var fallbackVoice = arVoices.last;
            await _flutterTts.setVoice({
              "name": fallbackVoice['name'],
              "locale": fallbackVoice['locale']
            });
            // Lower pitch significantly to make it sound deeper/more male
            await _flutterTts.setPitch(0.8);
          }
        } catch (e) {
          print('Error setting specific voice: $e');
        }
      }

      _flutterTts.setStartHandler(() {
        print('TTS Started');
        isPlaying.value = true;
      });

      _flutterTts.setCompletionHandler(() {
        print('TTS Completed');
        isPlaying.value = false;
        playingAyahNumber.value = -1;
      });

      _flutterTts.setErrorHandler((msg) {
        print('TTS Error: $msg');
        isPlaying.value = false;
        playingAyahNumber.value = -1;
        Get.snackbar('Recitation Error', 'Could not play audio: $msg');
      });
    } catch (e) {
      print('TTS Init Error: $e');
    }
  }

  Future<void> speakAyah(Ayah ayah) async {
    if (isPlaying.value && playingAyahNumber.value == ayah.numberInSurah) {
      await stopSpeaking();
      return;
    }

    await stopSpeaking();
    playingAyahNumber.value = ayah.numberInSurah;
    isPlaying.value = true;

    // Arabic text usually needs to be cleaned of some marks for better TTS
    // but flutter_tts usually handles standard Arabic well.
    await _flutterTts.speak(ayah.text);
  }

  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
    isPlaying.value = false;
    playingAyahNumber.value = -1;
  }

  @override
  void onClose() {
    _flutterTts.stop();
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
      print('Error loading surahs: $e');
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
      print('Error loading ayahs: $e');
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
