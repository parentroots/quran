import 'package:get/get.dart';

// Controllers
import '../../modules/home/controllers/home_controller.dart';
import '../../modules/quran/controllers/quran_controller.dart';
import '../../modules/hadith/controllers/hadith_controller.dart';
import '../../modules/prayer/controllers/prayer_controller.dart';
import '../../modules/qibla/controllers/qibla_controller.dart';
import '../../modules/settings/controllers/settings_controller.dart';
import '../../modules/tasbeeh/controllers/tasbeeh_controller.dart';
import '../../modules/dua/controllers/dua_controller.dart';
import '../../modules/zakat/controllers/zakat_controller.dart';
import '../../modules/names/controllers/names_controller.dart';
import '../../modules/calendar/controllers/calendar_controller.dart';

/// Central dependency injection binding
/// This binding is initialized once at app startup and manages all core dependencies
class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Core controllers that should be available throughout the app lifecycle
    // Using lazyPut for memory efficiency - controllers are created only when first accessed

    // Home controller - always needed
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);

    // Feature controllers - lazy loaded
    Get.lazyPut<QuranController>(() => QuranController());
    Get.lazyPut<HadithController>(() => HadithController());
    Get.lazyPut<PrayerController>(() => PrayerController());
    Get.lazyPut<QiblaController>(() => QiblaController());
    Get.lazyPut<SettingsController>(() => SettingsController());
    Get.lazyPut<TasbeehController>(() => TasbeehController());
    Get.lazyPut<DuaController>(() => DuaController());
    Get.lazyPut<ZakatController>(() => ZakatController());
    Get.lazyPut<NamesController>(() => NamesController());
    Get.lazyPut<CalendarController>(() => CalendarController());
  }
}
