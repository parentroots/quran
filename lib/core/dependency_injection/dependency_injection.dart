import 'package:get/get.dart';

// Controllers - App Modules
import '../../features/screens/home/controller/home_controller.dart';
import '../../features/screens/quran/controller/quran_controller.dart' as module_quran;
import '../../features/screens/hadith/controller/hadith_controller.dart' as module_hadith;
import '../../features/screens/prayer/controller/prayer_controller.dart';
import '../../features/screens/qibla/controller/qibla_controller.dart' as module_qibla;
import '../../features/screens/settings/controller/settings_controller.dart' as module_settings;
import '../../features/screens/tasbeeh/controller/tasbeeh_controller.dart';
import '../../features/screens/dua/controller/dua_controller.dart';
import '../../features/screens/zakat/controller/zakat_controller.dart';
import '../../features/screens/allah_names/controller/names_controller.dart';
import '../../features/screens/calender/controller/calendar_controller.dart';

// Services
import '../storage/local_storage.dart';
import '../../services/notification_service.dart';
import '../../services/location_service.dart';
import '../../services/tts_service.dart';
import '../../services/zakat_service.dart';
import '../../services/prayer_service.dart';

class DependencyInjection extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<LocalStorage>(() => LocalStorage(), fenix: true);
    Get.lazyPut<NotificationService>(() => NotificationService(), fenix: true);
    Get.lazyPut<LocationService>(() => LocationService(), fenix: true);
    Get.lazyPut<TtsService>(() => TtsService(), fenix: true);
    Get.lazyPut<ZakatService>(() => ZakatService(), fenix: true);
    Get.lazyPut<PrayerService>(() => PrayerService(), fenix: true);


    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<module_quran.QuranController>(() => module_quran.QuranController(), fenix: true);
    Get.lazyPut<module_hadith.HadithController>(() => module_hadith.HadithController(), fenix: true);
    Get.lazyPut<PrayerController>(() => PrayerController(), fenix: true);
    Get.lazyPut<module_qibla.QiblaController>(() => module_qibla.QiblaController(), fenix: true);
    Get.lazyPut<module_settings.SettingsController>(() => module_settings.SettingsController(), fenix: true);
    Get.lazyPut<TasbeehController>(() => TasbeehController(), fenix: true);
    Get.lazyPut<DuaController>(() => DuaController(), fenix: true);
    Get.lazyPut<ZakatController>(() => ZakatController(), fenix: true);
    Get.lazyPut<NamesController>(() => NamesController(), fenix: true);
    Get.lazyPut<CalendarController>(() => CalendarController(), fenix: true);
  }
}
