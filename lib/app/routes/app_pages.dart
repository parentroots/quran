import 'package:get/get.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/quran/views/quran_view.dart';
import '../modules/quran/views/surah_detail_view.dart';
import '../modules/quran/bindings/quran_binding.dart';
import '../modules/hadith/views/hadith_view.dart';
import '../modules/hadith/views/hadith_detail_view.dart';
import '../modules/hadith/bindings/hadith_binding.dart';
import '../modules/qibla/views/qibla_view.dart';
import '../modules/qibla/bindings/qibla_binding.dart';
import '../modules/prayer/views/prayer_view.dart';
import '../modules/prayer/bindings/prayer_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/tasbeeh/views/tasbeeh_view.dart';
import '../modules/tasbeeh/bindings/tasbeeh_binding.dart';
import '../modules/dua/views/dua_view.dart';
import '../modules/dua/bindings/dua_binding.dart';
import '../modules/zakat/views/zakat_view.dart';
import '../modules/zakat/bindings/zakat_binding.dart';
import '../modules/names/views/names_view.dart';
import '../modules/names/bindings/names_binding.dart';
import '../modules/calendar/views/calendar_view.dart';
import '../modules/calendar/bindings/calendar_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.QURAN,
      page: () => const QuranView(),
      binding: QuranBinding(),
    ),
    GetPage(
      name: _Paths.SURAH_DETAIL,
      page: () => SurahDetailView(),
      binding: QuranBinding(),
    ),
    GetPage(
      name: _Paths.HADITH,
      page: () => const HadithView(),
      binding: HadithBinding(),
    ),
    GetPage(
      name: _Paths.HADITH_DETAIL,
      page: () => const HadithDetailView(),
      binding: HadithBinding(),
    ),
    GetPage(
      name: _Paths.QIBLA,
      page: () => const QiblaView(),
      binding: QiblaBinding(),
    ),
    GetPage(
      name: _Paths.PRAYER,
      page: () => const PrayerView(),
      binding: PrayerBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.TASBEEH,
      page: () => const TasbeehView(),
      binding: TasbeehBinding(),
    ),
    GetPage(
      name: _Paths.DUA,
      page: () => const DuaView(),
      binding: DuaBinding(),
    ),
    GetPage(
      name: _Paths.ZAKAT,
      page: () => const ZakatView(),
      binding: ZakatBinding(),
    ),
    GetPage(
      name: _Paths.NAMES,
      page: () => const NamesView(),
      binding: NamesBinding(),
    ),
    GetPage(
      name: _Paths.CALENDAR,
      page: () => const CalendarView(),
      binding: CalendarBinding(),
    ),
  ];
}
