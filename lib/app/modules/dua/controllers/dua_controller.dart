import 'package:get/get.dart';
import '../../../data/models/dua_model.dart';

class DuaController extends GetxController {
  final RxList<Dua> allDuas = <Dua>[].obs;
  final RxList<Dua> filteredDuas = <Dua>[].obs;
  final RxString selectedCategory = 'সব'.obs;

  final List<DuaCategory> categories = [
    DuaCategory(name: 'সব', icon: '🙏'),
    DuaCategory(name: 'সকাল-সন্ধ্যা', icon: '🌅'),
    DuaCategory(name: 'নামাজ', icon: '📿'),
    DuaCategory(name: 'ভ্রমণ', icon: '✈️'),
    DuaCategory(name: 'অসুস্থতা', icon: '🏥'),
  ];

  @override
  void onInit() {
    super.onInit();
    _loadMockData();
  }

  void _loadMockData() {
    final mockDuas = [
      Dua(
        id: '1',
        category: 'সকাল-সন্ধ্যা',
        title: 'আয়াতুল কুরসী',
        arabic: 'اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ...',
        translation:
            'আল্লাহ, তিনি ছাড়া অন্য কোনো সত্য ইলাহ নেই। তিনি চিরঞ্জীব, সর্বসত্ত্বার ধারক।',
        transliteration: 'Allahu la ilaha illa Huwal-Haiyul-Qaiyum...',
        reference: 'সূরা আল-বাকারাহ: ২৫৫',
      ),
      Dua(
        id: '2',
        category: 'নামাজ',
        title: 'প্রবেশের দোয়া',
        arabic: 'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
        translation: 'হে আল্লাহ! আমার জন্য তোমার রহমতের দরজাগুলো খুলে দাও।',
        transliteration: 'Allahummaf-tah li abwaba rahmatik',
        reference: 'মুসলিম: ৭১৩',
      ),
      Dua(
        id: '3',
        category: 'ভ্রমণ',
        title: 'সফরের দোয়া',
        arabic:
            'سُبْحانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ',
        translation:
            'পবিত্র সেই সত্তা যিনি এগুলোকে আমাদের বশীভূত করে দিয়েছেন, অথচ আমরা এদের বশীভূত করতে পারতাম না।',
        transliteration: 'Subhanalladhee sakhkhara lana hadha...',
        reference: 'সূরা আয-যুখরুফ: ১৩',
      ),
    ];
    allDuas.assignAll(mockDuas);
    filteredDuas.assignAll(mockDuas);
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    if (category == 'সব') {
      filteredDuas.assignAll(allDuas);
    } else {
      filteredDuas
          .assignAll(allDuas.where((d) => d.category == category).toList());
    }
  }
}
