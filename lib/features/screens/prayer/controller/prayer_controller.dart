import 'package:get/get.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../services/notification_service.dart';
import '../../../../services/location_service.dart';
import '../../../../services/prayer_service.dart';
import '../data/prayer_model.dart';

class PrayerController extends GetxController {
  final LocalStorage _storageService = Get.find();
  final NotificationService _notificationService = Get.find();
  final LocationService _locationService = Get.find();
  final PrayerService _prayerService = Get.find();

  final Rx<PrayerTimes?> todayPrayerTimes = Rx<PrayerTimes?>(null);
  final RxList<PrayerAlarm> alarms = <PrayerAlarm>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxDouble userLatitude = 0.0.obs;
  final RxDouble userLongitude = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    initPrayerTimes();
  }

  Future<void> initPrayerTimes() async {
    await getUserLocation();
    calculatePrayerTimes();
    loadSavedAlarms();
  }

  Future<void> getUserLocation() async {
    try {
      isLoading.value = true;

      // Try to get cached location
      final cachedLocation = _storageService.getLocation();
      if (cachedLocation != null) {
        userLatitude.value = cachedLocation['latitude']!;
        userLongitude.value = cachedLocation['longitude']!;
      }

      // Get current position via LocationService
      final position = await _locationService.getCurrentLocation();
      if (position != null) {
        userLatitude.value = position.latitude;
        userLongitude.value = position.longitude;
        // Cache location
        await _storageService.saveLocation(
            position.latitude, position.longitude);
      }
    } catch (e) {
      errorMessage.value = 'অবস্থান পেতে ত্রুটি: ${e.toString()}';
      // log error
    } finally {
      isLoading.value = false;
    }
  }

  void calculatePrayerTimes() {
    todayPrayerTimes.value =
        _prayerService.calculatePrayerTimes(DateTime.now());

    // Initialize alarms if not already set
    if (alarms.isEmpty) {
      initializeDefaultAlarms();
    }
  }

  void initializeDefaultAlarms() {
    final times = todayPrayerTimes.value;
    if (times == null) return;

    alarms.value = [
      PrayerAlarm(
        prayerName: 'ফজর',
        time: times.fajr,
        isEnabled: true,
        notificationId: 1,
      ),
      PrayerAlarm(
        prayerName: 'যোহর',
        time: times.dhuhr,
        isEnabled: true,
        notificationId: 2,
      ),
      PrayerAlarm(
        prayerName: 'আসর',
        time: times.asr,
        isEnabled: true,
        notificationId: 3,
      ),
      PrayerAlarm(
        prayerName: 'মাগরিব',
        time: times.maghrib,
        isEnabled: true,
        notificationId: 4,
      ),
      PrayerAlarm(
        prayerName: 'এশা',
        time: times.isha,
        isEnabled: true,
        notificationId: 5,
      ),
    ];
  }

  void loadSavedAlarms() {
    final savedAlarms = _storageService.getPrayerAlarms();
    if (savedAlarms.isNotEmpty) {
      alarms.value =
          savedAlarms.map((json) => PrayerAlarm.fromJson(json)).toList();
    }
  }

  Future<void> toggleAlarm(int index) async {
    final alarm = alarms[index];
    final updatedAlarm = alarm.copyWith(isEnabled: !alarm.isEnabled);
    alarms[index] = updatedAlarm;

    if (updatedAlarm.isEnabled) {
      await scheduleAlarm(updatedAlarm);
    } else {
      await cancelAlarm(updatedAlarm);
    }

    await saveAlarms();
  }

  Future<void> updateAlarmTime(int index, DateTime newTime) async {
    final alarm = alarms[index];
    final timeStr = _formatTime(newTime);
    final updatedAlarm = alarm.copyWith(time: timeStr);
    alarms[index] = updatedAlarm;

    if (updatedAlarm.isEnabled) {
      await scheduleAlarm(updatedAlarm);
    } else {
      Get.snackbar(
        'সফল',
        '${alarm.prayerName} নামাজের সময় পরিবর্তন করা হয়েছে',
        duration: const Duration(seconds: 2),
      );
    }

    await saveAlarms();
  }

  String _formatTime(DateTime time) {
    final hour =
        time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final minute = time.minute.toString().padLeft(2, '0');
    final hourStr = hour.toString().padLeft(2, '0');
    return '$hourStr:$minute $period';
  }

  Future<void> scheduleAlarm(PrayerAlarm alarm) async {
    try {
      final scheduledTime = _parseTime(alarm.time);

      await _notificationService.schedulePrayerNotification(
        id: alarm.notificationId ?? 0,
        title: '${alarm.prayerName} নামাজের সময়',
        body: 'এখন ${alarm.prayerName} নামাজের সময়',
        scheduledTime: scheduledTime,
      );

      Get.snackbar(
        'সফল',
        '${alarm.prayerName} নামাজের অ্যালার্ম চালু হয়েছে',
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      // log error
    }
  }

  Future<void> cancelAlarm(PrayerAlarm alarm) async {
    try {
      await _notificationService.cancelPrayerNotification(
        alarm.notificationId ?? 0,
      );

      Get.snackbar(
        'সফল',
        '${alarm.prayerName} নামাজের অ্যালার্ম বন্ধ হয়েছে',
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      // log error
    }
  }

  Future<void> saveAlarms() async {
    final alarmsJson = alarms.map((a) => a.toJson()).toList();
    await _storageService.savePrayerAlarms(alarmsJson);
  }

  DateTime _parseTime(String timeStr) {
    // Parse time string like "05:30 AM"
    final parts = timeStr.split(' ');
    final timeParts = parts[0].split(':');
    int hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final isPM = parts.length > 1 && parts[1].toUpperCase() == 'PM';

    if (isPM && hour != 12) {
      hour += 12;
    } else if (!isPM && hour == 12) {
      hour = 0;
    }

    final now = DateTime.now();
    var scheduledTime = DateTime(now.year, now.month, now.day, hour, minute);

    // If time has passed today, schedule for tomorrow
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    return scheduledTime;
  }

  String getNextPrayer() {
    final now = DateTime.now();
    final times = todayPrayerTimes.value;
    if (times == null) return 'ফজর';

    final currentMinutes = now.hour * 60 + now.minute;

    final fajrMinutes = _getMinutesFromTime(times.fajr);
    final dhuhrMinutes = _getMinutesFromTime(times.dhuhr);
    final asrMinutes = _getMinutesFromTime(times.asr);
    final maghribMinutes = _getMinutesFromTime(times.maghrib);
    final ishaMinutes = _getMinutesFromTime(times.isha);

    if (currentMinutes < fajrMinutes) return 'ফজর';
    if (currentMinutes < dhuhrMinutes) return 'যোহর';
    if (currentMinutes < asrMinutes) return 'আসর';
    if (currentMinutes < maghribMinutes) return 'মাগরিব';
    if (currentMinutes < ishaMinutes) return 'এশা';
    return 'ফজর';
  }

  int _getMinutesFromTime(String timeStr) {
    final parts = timeStr.split(' ');
    final timeParts = parts[0].split(':');
    int hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final isPM = parts.length > 1 && parts[1].toUpperCase() == 'PM';

    if (isPM && hour != 12) {
      hour += 12;
    } else if (!isPM && hour == 12) {
      hour = 0;
    }

    return hour * 60 + minute;
  }

  Future<void> refreshPrayerTimes() async {
    await getUserLocation();
    calculatePrayerTimes();
  }
}
