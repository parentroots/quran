import 'package:get/get.dart';

// Route names
import 'app_route_names.dart';

// Views
import '../ui/screens/splash_view.dart';
import '../ui/screens/home_view.dart';
import '../ui/screens/quran_view.dart';
import '../ui/screens/surah_detail_view.dart';
import '../ui/screens/hadith_view.dart';
import '../ui/screens/hadith_detail_view.dart';
import '../ui/screens/qibla_view.dart';
import '../ui/screens/prayer_view.dart';
import '../ui/screens/settings_view.dart';
import '../ui/screens/tasbeeh_view.dart';
import '../ui/screens/dua_view.dart';
import '../ui/screens/zakat_view.dart';
import '../ui/screens/name_view.dart';
import '../ui/screens/calendar_view.dart';

/// Application pages configuration
/// Defines all routes and their corresponding pages
/// Dependencies are managed centrally via AppBinding
class AppPages {
  AppPages._();

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
