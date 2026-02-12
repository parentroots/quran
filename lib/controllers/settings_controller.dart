import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/storage/local_storage.dart';

class SettingsController extends GetxController {
  final LocalStorage _storageService = Get.find();

  final RxBool isDarkMode = false.obs;
  final RxDouble arabicFontSize = 28.0.obs;
  final RxDouble translationFontSize = 16.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  void loadSettings() {
    isDarkMode.value = _storageService.getDarkMode();
    arabicFontSize.value = _storageService.getArabicFontSize();
    translationFontSize.value = _storageService.getTranslationFontSize();
  }

  Future<void> toggleDarkMode() async {
    isDarkMode.value = !isDarkMode.value;
    await _storageService.setDarkMode(isDarkMode.value);

    Get.changeThemeMode(
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
    );
  }

  Future<void> updateArabicFontSize(double size) async {
    arabicFontSize.value = size;
    await _storageService.setArabicFontSize(size);
  }

  Future<void> updateTranslationFontSize(double size) async {
    translationFontSize.value = size;
    await _storageService.setTranslationFontSize(size);
  }

  Future<void> clearAllData() async {
    Get.defaultDialog(
      title: 'নিশ্চিত করুন',
      middleText: 'আপনি কি সব ডেটা মুছে ফেলতে চান?',
      textConfirm: 'হ্যাঁ',
      textCancel: 'না',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        await _storageService.clearAllData();
        Get.back();
        Get.snackbar(
          'সফল',
          'সব ডেটা মুছে ফেলা হয়েছে',
          duration: const Duration(seconds: 2),
        );

        // Restart the app
        Get.offAllNamed('/home');
      },
    );
  }
}
