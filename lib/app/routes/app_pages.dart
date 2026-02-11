import 'package:get/get.dart';

// Route names
import 'app_route_names.dart';

// Views
import '../modules/home/views/home_view.dart';
import '../modules/quran/views/quran_view.dart';
import '../modules/quran/views/surah_detail_view.dart';
import '../modules/hadith/views/hadith_view.dart';
import '../modules/hadith/views/hadith_detail_view.dart';
import '../modules/qibla/views/qibla_view.dart';
import '../modules/prayer/views/prayer_view.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/tasbeeh/views/tasbeeh_view.dart';
import '../modules/dua/views/dua_view.dart';
import '../modules/zakat/views/zakat_view.dart';
import '../modules/names/view/name_view.dart';
import '../modules/calendar/views/calendar_view.dart';

/// Application pages configuration
/// Defines all routes and their corresponding pages
/// Dependencies are managed centrally via AppBinding
class AppPages {
  AppPages._();

  /// Initial route when app starts
  static const String initial = AppRouteNames.home;

  /// All application routes
  static final List<GetPage> routes = [
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
