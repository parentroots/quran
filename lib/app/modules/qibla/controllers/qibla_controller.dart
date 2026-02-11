import 'dart:async';
import 'package:flutter_compass_v2/flutter_compass_v2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math' as math;
import '../../../services/storage_service.dart';

class QiblaController extends GetxController {
  final StorageService _storageService = Get.find();

  final RxDouble qiblaDirection = 0.0.obs;
  final RxDouble compassHeading = 0.0.obs;
  final RxBool isLoading = false.obs;
  final RxBool hasPermission = false.obs;
  final RxString errorMessage = ''.obs;
  final RxDouble userLatitude = 0.0.obs;
  final RxDouble userLongitude = 0.0.obs;

  StreamSubscription<CompassEvent>? _compassSubscription;

  // Kaaba coordinates
  static const double kaabaLatitude = 21.4225;
  static const double kaabaLongitude = 39.8262;

  @override
  void onInit() {
    super.onInit();
    initQibla();
  }

  @override
  void onClose() {
    _compassSubscription?.cancel();
    super.onClose();
  }

  Future<void> initQibla() async {
    await checkPermissions();
    if (hasPermission.value) {
      await getUserLocation();
      startCompass();
    }
  }

  Future<void> checkPermissions() async {
    try {
      // Check location permission
      var locationStatus = await Permission.location.status;
      if (!locationStatus.isGranted) {
        locationStatus = await Permission.location.request();
      }

      hasPermission.value = locationStatus.isGranted;

      if (!hasPermission.value) {
        errorMessage.value = 'অবস্থান অনুমতি প্রয়োজন';
      }
    } catch (e) {
      errorMessage.value = 'অনুমতি চেক করতে ত্রুটি: ${e.toString()}';
      print('Error checking permissions: $e');
    }
  }

  Future<void> getUserLocation() async {
    try {
      isLoading.value = true;

      // Try to get cached location first
      final cachedLocation = _storageService.getLocation();
      if (cachedLocation != null) {
        userLatitude.value = cachedLocation['latitude']!;
        userLongitude.value = cachedLocation['longitude']!;
        calculateQiblaDirection();
        isLoading.value = false;
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      userLatitude.value = position.latitude;
      userLongitude.value = position.longitude;

      // Cache location
      await _storageService.saveLocation(position.latitude, position.longitude);

      calculateQiblaDirection();
    } catch (e) {
      errorMessage.value = 'অবস্থান পেতে ত্রুটি: ${e.toString()}';
      print('Error getting location: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void calculateQiblaDirection() {
    final double userLat = _degreesToRadians(userLatitude.value);
    final double userLng = _degreesToRadians(userLongitude.value);
    final double kaabaLat = _degreesToRadians(kaabaLatitude);
    final double kaabaLng = _degreesToRadians(kaabaLongitude);

    final double deltaLng = kaabaLng - userLng;

    final double y = math.sin(deltaLng);
    final double x = math.cos(userLat) * math.tan(kaabaLat) -
        math.sin(userLat) * math.cos(deltaLng);

    double direction = _radiansToDegrees(math.atan2(y, x));

    // Normalize to 0-360
    qiblaDirection.value = (direction + 360) % 360;
  }

  void startCompass() {
    _compassSubscription = FlutterCompass.events?.listen((CompassEvent event) {
      if (event.heading != null) {
        compassHeading.value = event.heading!;
      }
    });
  }

  double get qiblaAngle {
    // Calculate the angle between compass heading and qibla direction
    double angle = qiblaDirection.value - compassHeading.value;
    // Normalize to -180 to 180
    if (angle < -180) angle += 360;
    if (angle > 180) angle -= 360;
    return angle;
  }

  bool get isQiblaAligned {
    // Consider aligned if within 5 degrees
    return qiblaAngle.abs() < 5;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  double _radiansToDegrees(double radians) {
    return radians * (180 / math.pi);
  }

  Future<void> refreshLocation() async {
    await getUserLocation();
  }
}
