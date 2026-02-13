import 'package:get/get.dart';
import 'package:islamic_app/features/screens/prayer/view/prayer_view.dart';

// Route names
import '../features/screens/calender/view/calendar_view.dart';
import '../features/screens/dua/view/dua_view.dart';
import '../features/screens/hadith/view/hadith_detail_view.dart';
import '../features/screens/hadith/view/hadith_view.dart';
import '../features/screens/home/view/home_view.dart';
import '../features/screens/allah_names/view/name_view.dart';
import '../features/screens/qibla/view/qibla_view.dart';
import '../features/screens/quran/view/quran_view.dart';
import '../features/screens/settings/view/settings_view.dart';
import '../features/screens/splash/view/splash_view.dart';
import '../features/screens/quran/view/surah_detail_view.dart';
import '../features/screens/tasbeeh/view/tasbeeh_view.dart';
import '../features/screens/zakat/view/zakat_view.dart';
import 'app_route_names.dart';


class AppRoutes {
  AppRoutes._();

  /// Initial route when app starts
  /// Initial route when app starts
  static const String initial = AppRouteNames.splash;

  /// All application routes
  static final List<GetPage> routes = [
    // Splash
    GetPage(
      name: AppRouteNames.splash,
      page: () => const SplashView(),
      transition: Transition.fadeIn,
    ),

    // Home
    GetPage(
      name: AppRouteNames.home,
      page: () => const HomeView(),
      transition: Transition.fadeIn,
    ),

    // Quran
    GetPage(
      name: AppRouteNames.quran,
      page: () => const QuranView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRouteNames.surahDetail,
      page: () => SurahDetailView(),
      transition: Transition.rightToLeft,
    ),

    // Hadith
    GetPage(
      name: AppRouteNames.hadith,
      page: () => const HadithView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRouteNames.hadithDetail,
      page: () => const HadithDetailView(),
      transition: Transition.rightToLeft,
    ),

    // Prayer & Qibla
    GetPage(
      name: AppRouteNames.prayer,
      page: () => const PrayerView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRouteNames.qibla,
      page: () => const QiblaView(),
      transition: Transition.rightToLeft,
    ),

    // Islamic Tools
    GetPage(
      name: AppRouteNames.tasbeeh,
      page: () => const TasbeehView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRouteNames.dua,
      page: () => const DuaView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRouteNames.zakat,
      page: () => const ZakatView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRouteNames.names,
      page: () => const NamesView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRouteNames.calendar,
      page: () => const CalendarView(),
      transition: Transition.rightToLeft,
    ),

    // Settings
    GetPage(
      name: AppRouteNames.settings,
      page: () => const SettingsView(),
      transition: Transition.rightToLeft,
    ),
  ];
}
