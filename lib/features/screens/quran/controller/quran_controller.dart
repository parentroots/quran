import 'package:get/get.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/api_endpoint.dart';
import '../../../../services/tts_service.dart';
import '../data/quran_model.dart';

class QuranController extends GetxController {
  final LocalStorage _storageService = Get.find();
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
      final fetchedSurahs = await _fetchAllSurahs();
      await _storageService.saveSurahs(fetchedSurahs);
      surahs.value = fetchedSurahs;

      // Fetch ayahs for each surah
      for (var surah in fetchedSurahs) {
        final ayahs = await _fetchSurahAyahs(surah.number);
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

  // Fetch all Surahs from API
  Future<List<Surah>> _fetchAllSurahs() async {
    final response =
        await ApiService.get('${ApiEndpoint.quranBase}${ApiEndpoint.surah}');

    if (response.isSuccess) {
      final data = response.data['data'] as List;
      return data.map((json) => Surah.fromJson(json)).toList();
    }
    throw Exception(response.message);
  }

  // Fetch Ayahs of a Surah from API
  Future<List<Ayah>> _fetchSurahAyahs(int surahNumber) async {
    // Fetch Arabic (quran-uthmani), English transliteration (en.transliteration), and Bengali translation (bn.bengali) editions in one call
    final response = await ApiService.get(
      '${ApiEndpoint.quranBase}${ApiEndpoint.surah}/$surahNumber${ApiEndpoint.editions}/quran-uthmani,en.transliteration,bn.bengali',
    );

    if (response.isSuccess) {
      final data = response.data['data'] as List;

      // Extract Arabic, transliteration, and Bengali translation data from the response list
      // The API returns an array of editions. We need to find which is which.
      var arabicData;
      var transliterationData;
      var bengaliData;

      for (var edition in data) {
        if (edition['edition']['identifier'] == 'quran-uthmani') {
          arabicData = edition;
        } else if (edition['edition']['identifier'] == 'en.transliteration') {
          transliterationData = edition;
        } else if (edition['edition']['identifier'] == 'bn.bengali') {
          bengaliData = edition;
        }
      }

      if (arabicData == null || bengaliData == null) {
        throw Exception("Could not fetch required editions");
      }

      final arabicAyahs = arabicData['ayahs'] as List;
      final transliterationAyahs = transliterationData != null
          ? (transliterationData['ayahs'] as List)
          : null;
      final bengaliAyahs = bengaliData['ayahs'] as List;

      List<Ayah> ayahs = [];
      for (int i = 0; i < arabicAyahs.length; i++) {
        final arabicAyah = arabicAyahs[i];
        final transliterationAyah =
            transliterationAyahs != null && i < transliterationAyahs.length
                ? transliterationAyahs[i]
                : null;
        final bengaliAyah = bengaliAyahs[i];

        String? pronun = transliterationAyah != null
            ? engToBanglaPronunciation(transliterationAyah['text'])
            : null;

        ayahs.add(Ayah(
          number: arabicAyah['number'],
          text: arabicAyah['text'],
          numberInSurah: arabicAyah['numberInSurah'],
          juz: arabicAyah['juz'],
          manzil: arabicAyah['manzil'],
          page: arabicAyah['page'],
          ruku: arabicAyah['ruku'],
          hizbQuarter: arabicAyah['hizbQuarter'],
          sajda:
              arabicAyah['sajda'] is bool ? (arabicAyah['sajda'] ? 1 : 0) : 0,
          transliteration: pronun,
          translation: bengaliAyah['text'],
        ));
      }
      return ayahs;
    }
    throw Exception(response.message);
  }

  String engToBanglaPronunciation(String text) {
    if (text.isEmpty) return text;

    // Mapping for common English/Latin transliteration tokens to Bangla sounds
    Map<String, String> mapping = {
      'th': 'ছ',
      'kh': 'খ',
      'dh': 'দ',
      'sh': 'শ',
      'gh': 'গ',
      'ee': 'ঈ',
      'oo': 'উ',
      'aa': 'আ',
      'ai': 'আই',
      'au': 'আউ',
      'a': 'আ',
      'b': 'ব',
      'c': 'ক',
      'd': 'দ',
      'e': 'এ',
      'f': 'ফ',
      'g': 'গ',
      'h': 'হ',
      'i': 'ই',
      'j': 'জ',
      'k': 'ক',
      'l': 'ল',
      'm': 'ম',
      'n': 'ন',
      'o': 'ও',
      'p': 'প',
      'q': 'ক',
      'r': 'র',
      's': 'স',
      't': 'ত',
      'u': 'উ',
      'v': 'ভ',
      'w': 'ও',
      'x': 'ক্স',
      'y': 'য়',
      'z': 'য',
      '\'': '‘',
    };

    // Vowel Signs (Kar)
    Map<String, String> karMapping = {
      'আ': 'া',
      'ই': 'ি',
      'ঈ': 'ী',
      'উ': 'ু',
      'ঊ': 'ূ',
      'এ': 'ে',
      'ঐ': 'ৈ',
      'ও': 'ো',
      'ঔ': 'ৌ',
    };

    String result = text.toLowerCase();

    // 1. Initial character replacement
    var keys = mapping.keys.toList()
      ..sort((a, b) => b.length.compareTo(a.length));

    for (var key in keys) {
      result = result.replaceAll(key, mapping[key]!);
    }

    // 2. Convert vowels to Kar if preceded by a consonant
    // This is a simple heuristic: if a vowel follows a consonant, change it to Kar.
    // List of Bangla consonants
    String consonants = "কখগঘঙচছজঝঞটঠডঢণতথদধনপফবভমযরলশষসহড়ঢ়য়ৎ";
    List<String> vowels = karMapping.keys.toList();

    String finalResult = "";
    for (int i = 0; i < result.length; i++) {
      String char = result[i];
      if (i > 0 &&
          vowels.contains(char) &&
          consonants.contains(result[i - 1])) {
        finalResult += karMapping[char]!;
      } else {
        finalResult += char;
      }
    }

    return finalResult;
  }

  Future<void> loadSurahAyahs(Surah surah) async {
    try {
      isLoadingAyahs.value = true;
      currentSurah.value = surah;

      // Load from cache first
      currentAyahs.value = _storageService.getAyahs(surah.number);

      // If no ayahs in cache, fetch from API
      if (currentAyahs.isEmpty) {
        final ayahs = await _fetchSurahAyahs(surah.number);
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
