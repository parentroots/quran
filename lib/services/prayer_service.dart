import 'dart:math' as math;
import '../features/screens/prayer/data/prayer_model.dart';

class PrayerService {
  // Singleton Pattern
  static final PrayerService _instance = PrayerService._internal();
  factory PrayerService() => _instance;
  PrayerService._internal();

  Future<PrayerService> init() async {
    return this;
  }

  PrayerTimes calculatePrayerTimes(DateTime date) {
    // This is a simplified mock. In a real app, it would use a library.
    return PrayerTimes(
      fajr: '05:30 AM',
      sunrise: '06:45 AM',
      dhuhr: '12:15 PM',
      asr: '03:45 PM',
      maghrib: '06:00 PM',
      isha: '07:30 PM',
      date: date,
    );
  }

  double calculateQiblaDirection(double userLat, double userLng) {
    const double kaabaLat = 21.4225;
    const double kaabaLng = 39.8262;

    final double uLat = _degreesToRadians(userLat);
    final double uLng = _degreesToRadians(userLng);
    final double kLat = _degreesToRadians(kaabaLat);
    final double kLng = _degreesToRadians(kaabaLng);

    final double deltaLng = kLng - uLng;

    final double y = math.sin(deltaLng);
    final double x =
        math.cos(uLat) * math.tan(kLat) - math.sin(uLat) * math.cos(deltaLng);

    double direction = _radiansToDegrees(math.atan2(y, x));
    return (direction + 360) % 360;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  double _radiansToDegrees(double radians) {
    return radians * (180 / math.pi);
  }
}
