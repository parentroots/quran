import 'dart:async';
import 'package:flutter_compass_v2/flutter_compass_v2.dart';
import 'package:get/get.dart';
import '../core/storage/local_storage.dart';
import '../services/location_service.dart';
import '../services/prayer_service.dart';

class QiblaController extends GetxController {
  final LocalStorage _storageService = Get.find();
  final LocationService _locationService = Get.find();
  final PrayerService _prayerService = Get.find();

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
    hasPermission.value = await _locationService.checkPermissions();
    if (!hasPermission.value) {
      errorMessage.value = 'লোকেশন অনুমতি প্রয়োজন';
    } else {
      errorMessage.value = '';
    }
  }

  Future<void> getUserLocation() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final position = await _locationService.getCurrentLocation();
      if (position != null) {
        userLatitude.value = position.latitude;
        userLongitude.value = position.longitude;
        await _storageService.saveLocation(
            position.latitude, position.longitude);
        calculateQiblaDirection();
      } else {
        // Try to get cached location
        final cachedLocation = _storageService.getLocation();
        if (cachedLocation != null) {
          userLatitude.value = cachedLocation['latitude']!;
          userLongitude.value = cachedLocation['longitude']!;
          calculateQiblaDirection();
        } else {
          errorMessage.value = 'লোকেশন পাওয়া যায়নি';
        }
      }
    } catch (e) {
      errorMessage.value = 'লোকেশন পেতে ত্রুটি: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void calculateQiblaDirection() {
    if (userLatitude.value == 0.0) return;
    qiblaDirection.value = _prayerService.calculateQiblaDirection(
        userLatitude.value, userLongitude.value);
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
    double angle = qiblaDirection.value - compassHeading.value;
    if (angle < -180) angle += 360;
    if (angle > 180) angle -= 360;
    return angle;
  }

  bool get isQiblaAligned {
    return qiblaAngle.abs() < 5;
  }

  Future<void> refreshLocation() async {
    await getUserLocation();
  }
}
