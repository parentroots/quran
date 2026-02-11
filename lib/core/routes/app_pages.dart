import 'package:get/get.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/quran/presentation/pages/quran_page.dart';
import '../../features/quran/presentation/pages/surah_detail_page.dart';
import '../../features/hadith/presentation/pages/hadith_page.dart';
import '../../features/hadith/presentation/pages/hadith_detail_page.dart';
import '../../features/qibla/presentation/pages/qibla_page.dart';
import '../../features/prayer_times/presentation/pages/prayer_times_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/quran/presentation/bindings/quran_binding.dart';
import '../../features/hadith/presentation/bindings/hadith_binding.dart';
import '../../features/qibla/presentation/bindings/qibla_binding.dart';
import '../../features/prayer_times/presentation/bindings/prayer_times_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();
  
  static const INITIAL = Routes.HOME;
  
  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomePage(),
    ),
    GetPage(
      name: Routes.QURAN,
      page: () => const QuranPage(),
      binding: QuranBinding(),
    ),
    GetPage(
      name: Routes.SURAH_DETAIL,
      page: () => const SurahDetailPage(),
    ),
    GetPage(
      name: Routes.HADITH,
      page: () => const HadithPage(),
      binding: HadithBinding(),
    ),
    GetPage(
      name: Routes.HADITH_DETAIL,
      page: () => const HadithDetailPage(),
    ),
    GetPage(
      name: Routes.QIBLA,
      page: () => const QiblaPage(),
      binding: QiblaBinding(),
    ),
    GetPage(
      name: Routes.PRAYER_TIMES,
      page: () => const PrayerTimesPage(),
      binding: PrayerTimesBinding(),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsPage(),
    ),
  ];
}
