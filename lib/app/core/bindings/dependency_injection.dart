import 'package:get/get.dart';

// Controllers - App Modules
import '../../modules/home/controllers/home_controller.dart';
import '../../modules/quran/controllers/quran_controller.dart' as module_quran;
import '../../modules/hadith/controllers/hadith_controller.dart'
    as module_hadith;
import '../../modules/prayer/controllers/prayer_controller.dart';
import '../../modules/qibla/controllers/qibla_controller.dart' as module_qibla;
import '../../modules/settings/controllers/settings_controller.dart'
    as module_settings;
import '../../modules/tasbeeh/controllers/tasbeeh_controller.dart';
import '../../modules/dua/controllers/dua_controller.dart';
import '../../modules/zakat/controllers/zakat_controller.dart';
import '../../modules/names/controllers/names_controller.dart';
import '../../modules/calendar/controllers/calendar_controller.dart';

// Services
import '../../services/api_service.dart';
import '../../services/storage_service.dart';
import '../../services/notification_service.dart';

/// Centralized dependency injection class
/// This class manages all core dependencies, controllers, and services
class DependencyInjection extends Bindings {
  @override
  void dependencies() {
    // --- Services ---
    // These are already put in main.dart initServices, but lazyPut ensures
    // we can access them via Get.find throughout the app.
    Get.lazyPut<ApiService>(() => Get.find<ApiService>(), fenix: true);
    Get.lazyPut<StorageService>(() => Get.find<StorageService>(), fenix: true);
    Get.lazyPut<NotificationService>(() => Get.find<NotificationService>(),
        fenix: true);

    // --- Module Controllers ---
    // Using fenix: true ensures they are recreated if they were deleted from memory
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<module_quran.QuranController>(
        () => module_quran.QuranController(),
        fenix: true);
    Get.lazyPut<module_hadith.HadithController>(
        () => module_hadith.HadithController(),
        fenix: true);
    Get.lazyPut<PrayerController>(() => PrayerController(), fenix: true);
    Get.lazyPut<module_qibla.QiblaController>(
        () => module_qibla.QiblaController(),
        fenix: true);
    Get.lazyPut<module_settings.SettingsController>(
        () => module_settings.SettingsController(),
        fenix: true);
    Get.lazyPut<TasbeehController>(() => TasbeehController(), fenix: true);
    Get.lazyPut<DuaController>(() => DuaController(), fenix: true);
    Get.lazyPut<ZakatController>(() => ZakatController(), fenix: true);
    Get.lazyPut<NamesController>(() => NamesController(), fenix: true);
    Get.lazyPut<CalendarController>(() => CalendarController(), fenix: true);
  }
}
