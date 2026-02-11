part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const QURAN = _Paths.QURAN;
  static const SURAH_DETAIL = _Paths.SURAH_DETAIL;
  static const HADITH = _Paths.HADITH;
  static const HADITH_DETAIL = _Paths.HADITH_DETAIL;
  static const QIBLA = _Paths.QIBLA;
  static const PRAYER = _Paths.PRAYER;
  static const SETTINGS = _Paths.SETTINGS;
  static const TASBEEH = _Paths.TASBEEH;
  static const DUA = _Paths.DUA;
  static const ZAKAT = _Paths.ZAKAT;
  static const NAMES = _Paths.NAMES;
  static const CALENDAR = _Paths.CALENDAR;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const QURAN = '/quran';
  static const SURAH_DETAIL = '/surah-detail';
  static const HADITH = '/hadith';
  static const HADITH_DETAIL = '/hadith-detail';
  static const QIBLA = '/qibla';
  static const PRAYER = '/prayer';
  static const SETTINGS = '/settings';
  static const TASBEEH = '/tasbeeh';
  static const DUA = '/dua';
  static const ZAKAT = '/zakat';
  static const NAMES = '/names';
  static const CALENDAR = '/calendar';
}
