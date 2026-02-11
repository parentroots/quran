import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/services/notification_service.dart';

class PrayerTimesController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  final NotificationService _notificationService = Get.find<NotificationService>();
  
  final RxMap<String, String> prayerTimes = <String, String>{}.obs;
  final RxBool isLoading = false.obs;
  final RxString currentPrayer = ''.obs;
  final RxString nextPrayer = ''.obs;
  final RxString timeUntilNext = ''.obs;
  
  final List<String> prayers = [
    'Fajr',
    'Dhuhr',
    'Asr',
    'Maghrib',
    'Isha',
  ];
  
  @override
  void onInit() {
    super.onInit();
    loadPrayerTimes();
    _updateCurrentPrayer();
  }
  
  Future<void> loadPrayerTimes() async {
    try {
      isLoading.value = true;
      
      // Get location
      final position = await Geolocator.getCurrentPosition();
      
      // Calculate prayer times (simplified calculation)
      // In production, use a proper prayer time calculation library
      final now = DateTime.now();
      
      prayerTimes.value = {
        'Fajr': _formatTime(5, 30),
        'Dhuhr': _formatTime(12, 30),
        'Asr': _formatTime(15, 45),
        'Maghrib': _formatTime(18, 15),
        'Isha': _formatTime(19, 45),
      };
      
      _updateCurrentPrayer();
      await _scheduleNotifications();
      
    } catch (e) {
      print('Error loading prayer times: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  void _updateCurrentPrayer() {
    final now = DateTime.now();
    final currentTime = now.hour * 60 + now.minute;
    
    String current = '';
    String next = '';
    
    for (int i = 0; i < prayers.length; i++) {
      final prayerTime = _parseTime(prayerTimes[prayers[i]] ?? '');
      
      if (currentTime < prayerTime) {
        next = prayers[i];
        current = i > 0 ? prayers[i - 1] : prayers.last;
        break;
      }
    }
    
    if (next.isEmpty) {
      current = prayers.last;
      next = prayers.first;
    }
    
    currentPrayer.value = current;
    nextPrayer.value = next;
    
    _calculateTimeUntilNext();
  }
  
  void _calculateTimeUntilNext() {
    final now = DateTime.now();
    final nextPrayerTime = prayerTimes[nextPrayer.value] ?? '';
    final parts = nextPrayerTime.split(':');
    
    if (parts.length == 2) {
      var nextTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(parts[0]),
        int.parse(parts[1].substring(0, 2)),
      );
      
      // If next prayer is tomorrow
      if (nextTime.isBefore(now)) {
        nextTime = nextTime.add(const Duration(days: 1));
      }
      
      final difference = nextTime.difference(now);
      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;
      
      timeUntilNext.value = '${hours}h ${minutes}m';
    }
  }
  
  String _formatTime(int hour, int minute) {
    final time = DateTime(2000, 1, 1, hour, minute);
    return DateFormat('hh:mm a').format(time);
  }
  
  int _parseTime(String timeStr) {
    if (timeStr.isEmpty) return 0;
    
    final parts = timeStr.split(':');
    if (parts.length != 2) return 0;
    
    var hour = int.parse(parts[0]);
    final minute = int.parse(parts[1].substring(0, 2));
    final isPM = timeStr.toLowerCase().contains('pm');
    
    if (isPM && hour != 12) hour += 12;
    if (!isPM && hour == 12) hour = 0;
    
    return hour * 60 + minute;
  }
  
  Future<void> _scheduleNotifications() async {
    // Cancel existing notifications
    await _notificationService.cancelAllNotifications();
    
    // Schedule new notifications for each prayer
    for (int i = 0; i < prayers.length; i++) {
      final prayer = prayers[i];
      final isEnabled = _storageService.isPrayerAlarmEnabled(prayer);
      
      if (isEnabled) {
        final timeStr = prayerTimes[prayer] ?? '';
        final parts = timeStr.split(':');
        
        if (parts.length == 2) {
          var hour = int.parse(parts[0]);
          final minute = int.parse(parts[1].substring(0, 2));
          final isPM = timeStr.toLowerCase().contains('pm');
          
          if (isPM && hour != 12) hour += 12;
          if (!isPM && hour == 12) hour = 0;
          
          final now = DateTime.now();
          var scheduledTime = DateTime(
            now.year,
            now.month,
            now.day,
            hour,
            minute,
          );
          
          // If time has passed today, schedule for tomorrow
          if (scheduledTime.isBefore(now)) {
            scheduledTime = scheduledTime.add(const Duration(days: 1));
          }
          
          await _notificationService.schedulePrayerNotification(
            id: i,
            title: '$prayer Prayer Time',
            body: 'It\'s time for $prayer prayer',
            scheduledTime: scheduledTime,
          );
        }
      }
    }
  }
  
  Future<void> togglePrayerAlarm(String prayer, bool value) async {
    await _storageService.setPrayerAlarmEnabled(prayer, value);
    await _scheduleNotifications();
  }
  
  bool isPrayerAlarmEnabled(String prayer) {
    return _storageService.isPrayerAlarmEnabled(prayer);
  }
}
