class ApiEndpoint {
  ApiEndpoint._();

  static const String baseUrl =
      "https://api.alquran.cloud/v1"; // Default base, though multiple might be used

  // Quran API
  static const String quranBase = "https://api.alquran.cloud/v1";
  static const String surah = "/surah";
  static const String editions = "/editions";
  static const String juz = "/juz";
  static const String page = "/page";
  static const String ayah = "/ayah";

  // Hadith API
  static const String hadithBase = "https://hadithapi.com/api";
  static const String hadithBooks = "/books"; // Placeholder if needed in future
}
