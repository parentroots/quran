import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../core/storage/local_storage.dart';
import '../core/models/tasbeeh_history_model.dart';

class TasbeehController extends GetxController {
  final LocalStorage _storageService = Get.find<LocalStorage>();

  final RxInt count = 0.obs;
  final RxInt targetCount = 33.obs;
  final RxInt lapCount = 0.obs;
  final RxString currentDhikr = 'SubhanAllah'.obs;

  final List<String> dhikrList = [
    'SubhanAllah',
    'Alhamdulillah',
    'Allahu Akbar',
    'La ilaha illallah',
    'Astaghfirullah',
  ];

  final RxList<TasbeehHistory> history = <TasbeehHistory>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  void increment() {
    count.value++;
    HapticFeedback.lightImpact();

    if (count.value >= targetCount.value) {
      saveToHistory();
      count.value = 0;
      lapCount.value++;
      HapticFeedback.vibrate();
      _moveToNextDhikr();
    }
  }

  void reset() {
    count.value = 0;
    lapCount.value = 0;
    HapticFeedback.mediumImpact();
  }

  void _moveToNextDhikr() {
    int index = dhikrList.indexOf(currentDhikr.value);
    index = (index + 1) % dhikrList.length;
    currentDhikr.value = dhikrList[index];
  }

  void setTarget(int target) {
    targetCount.value = target;
  }

  // History Methods
  void loadHistory() {
    history.value = _storageService.getTasbeehHistory();
  }

  Future<void> saveToHistory() async {
    final newItem = TasbeehHistory(
      dhikr: currentDhikr.value,
      count: targetCount.value,
      date: DateTime.now(),
    );
    await _storageService.saveTasbeehHistory(newItem);
    loadHistory();
  }

  Future<void> deleteHistoryItem(int index) async {
    await _storageService.deleteTasbeehHistory(index);
    loadHistory();
  }

  Future<void> clearAllHistory() async {
    await _storageService.clearTasbeehHistory();
    loadHistory();
  }
}
