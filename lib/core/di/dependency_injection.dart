import 'package:get/get.dart';

// Controllers - App Modules
import '../../controllers/home_controller.dart';
import '../../controllers/quran_controller.dart' as module_quran;
import '../../controllers/hadith_controller.dart' as module_hadith;
import '../../controllers/prayer_controller.dart';
import '../../controllers/qibla_controller.dart' as module_qibla;
import '../../controllers/settings_controller.dart' as module_settings;
import '../../controllers/tasbeeh_controller.dart';
import '../../controllers/dua_controller.dart';
import '../../controllers/zakat_controller.dart';
import '../../controllers/names_controller.dart';
import '../../controllers/calendar_controller.dart';

// Services
import '../../services/data_service.dart';
import '../storage/local_storage.dart';
import '../../services/notification_service.dart';
import '../../services/location_service.dart';
import '../../services/tts_service.dart';
import '../../services/zakat_service.dart';
import '../../services/prayer_service.dart';

/// Centralized dependency injection class
/// This class manages all core dependencies, controllers, and services
class DependencyInjection extends Bindings {
  @override
  void dependencies() {
    // --- Services ---
    // These are already put in main.dart initServices, but lazyPut ensures
    // we can access them via Get.find throughout the app.
    // Keys for core dependencies
    Get.lazyPut<DataService>(() => DataService(), fenix: true);
    Get.lazyPut<LocalStorage>(() => LocalStorage(), fenix: true);
    Get.lazyPut<NotificationService>(() => NotificationService(), fenix: true);
    Get.lazyPut<LocationService>(() => LocationService(), fenix: true);
    Get.lazyPut<TtsService>(() => TtsService(), fenix: true);
    Get.lazyPut<ZakatService>(() => ZakatService(), fenix: true);
    Get.lazyPut<PrayerService>(() => PrayerService(), fenix: true);

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
