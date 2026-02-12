import 'package:get/get.dart';
import '../core/storage/local_storage.dart';
import '../core/models/quran_model.dart';

class HomeController extends GetxController {
  final LocalStorage _storageService = Get.find();

  final RxBool isLoading = false.obs;
  final Rx<LastRead?> lastRead = Rx<LastRead?>(null);
  final RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadLastRead();
  }

  void loadLastRead() {
    lastRead.value = _storageService.getLastRead();
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  Surah? getSurah(int number) {
    return _storageService.getSurah(number);
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'সুপ্রভাত';
    } else if (hour < 17) {
      return 'শুভ অপরাহ্ন';
    } else {
      return 'শুভ সন্ধ্যা';
    }
  }

  String getCurrentPrayerTime() {
    final hour = DateTime.now().hour;
    if (hour < 5) {
      return 'ফজরের সময়';
    } else if (hour < 12) {
      return 'যোহরের সময়';
    } else if (hour < 16) {
      return 'আসরের সময়';
    } else if (hour < 19) {
      return 'মাগরিবের সময়';
    } else {
      return 'এশার সময়';
    }
  }
}
