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

  // Formatted coordinate strings for UI
  String get latString =>
      userLatitude.value == 0.0 ? '---' : userLatitude.value.toStringAsFixed(4);
  String get lngString => userLongitude.value == 0.0
      ? '---'
      : userLongitude.value.toStringAsFixed(4);

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
        errorMessage.value = 'লোকেশন অনুমতি প্রয়োজন';
      } else {
        errorMessage.value = '';
      }
    } catch (e) {
      errorMessage.value = 'ত্রুটি: ${e.toString()}';
    }
  }

  Future<void> getUserLocation() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Get current position (Skip cached check for "Refresh" accuracy)
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 10),
      );

      userLatitude.value = position.latitude;
      userLongitude.value = position.longitude;

      // Cache location for other services
      await _storageService.saveLocation(position.latitude, position.longitude);

      calculateQiblaDirection();
    } catch (e) {
      // If fails, try to get cached location
      final cachedLocation = _storageService.getLocation();
      if (cachedLocation != null) {
        userLatitude.value = cachedLocation['latitude']!;
        userLongitude.value = cachedLocation['longitude']!;
        calculateQiblaDirection();
      } else {
        errorMessage.value = 'লোকেশন পাওয়া যায়নি';
      }
    } finally {
      isLoading.value = false;
    }
  }

  void calculateQiblaDirection() {
    if (userLatitude.value == 0.0) return;

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
    _compassSubscription?.cancel();
    _compassSubscription = FlutterCompass.events?.listen((CompassEvent event) {
      if (event.heading != null) {
        compassHeading.value = event.heading!;
      }
    });
  }

  double get qiblaAngle {
    // Current direction relative to North
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
