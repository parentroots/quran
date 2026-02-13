import 'package:get/get.dart';
import '../../../../core/storage/local_storage.dart';
import '../../quran/data/quran_model.dart';
import '../data/daily_reminder_model.dart';

class HomeController extends GetxController {
  final LocalStorage _storageService = Get.find();

  final RxBool isLoading = false.obs;
  final Rx<LastRead?> lastRead = Rx<LastRead?>(null);
  final RxInt currentIndex = 0.obs;

  final RxList<Map<String, String>> reminderList =
      <Map<String, String>>[].obs;

  final RxInt currentReminderIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadLastRead();
    loadDailyReminders();

  }


  void loadDailyReminders(){

    reminderList.assignAll([
      {
        "title": "নিশ্চয়ই আল্লাহ মহান",
        "reference": "সূরা বাকারা ২:২৫৫",
      },
      {
        "title": "ধৈর্য ধরো, আল্লাহ তোমার সাথে আছেন",
        "reference": "সূরা আনফাল ৮:৪৬",
      },

      {
        "title": "ধৈর্য ধরো, আল্লাহ তোমার সাথে আছেন",
        "reference": "সূরা আনফাল ৮:৪৬",
      },


      {
        "title": "ধৈর্য ধরো, আল্লাহ তোমার সাথে আছেন",
        "reference": "সূরা আনফাল ৮:৪৬",
      },



      {
        "title": "ধৈর্য ধরো, আল্লাহ তোমার সাথে আছেন",
        "reference": "সূরা আনফাল ৮:৪৬",
      },


    ]);

    // in future firebase use
    //fetchFromFirebase();
  }


  // TODO this on for firebase remiver update

 /* Future<void> fetchFromFirebase() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("daily_reminders")
        .get();

    final data = snapshot.docs
        .map((doc) => ReminderModel.fromJson(doc.data()))
        .toList();

    reminderList.assignAll(data);
  }
*/


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
