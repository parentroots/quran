import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../quran/controllers/quran_controller.dart';
import '../../hadith/controllers/hadith_controller.dart';
import '../../prayer/controllers/prayer_controller.dart';
import '../../settings/controllers/settings_controller.dart';
import '../../tasbeeh/controllers/tasbeeh_controller.dart';
import '../../dua/controllers/dua_controller.dart';
import '../../zakat/controllers/zakat_controller.dart';
import '../../names/controllers/names_controller.dart';
import '../../calendar/controllers/calendar_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<QuranController>(() => QuranController());
    Get.lazyPut<HadithController>(() => HadithController());
    Get.lazyPut<PrayerController>(() => PrayerController());
    Get.lazyPut<SettingsController>(() => SettingsController());
    Get.lazyPut<TasbeehController>(() => TasbeehController());
    Get.lazyPut<DuaController>(() => DuaController());
    Get.lazyPut<ZakatController>(() => ZakatController());
    Get.lazyPut<NamesController>(() => NamesController());
    Get.lazyPut<CalendarController>(() => CalendarController());
  }
}
