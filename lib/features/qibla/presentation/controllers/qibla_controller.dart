import 'package:get/get.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class QiblaController extends GetxController {
  final RxBool hasPermission = false.obs;
  final RxBool isDeviceSupported = false.obs;
  final RxDouble qiblaDirection = 0.0.obs;
  final RxString errorMessage = ''.obs;
  
  StreamSubscription<QiblahDirection>? _qiblahStream;
  
  @override
  void onInit() {
    super.onInit();
    checkDeviceSupport();
  }
  
  @override
  void onClose() {
    _qiblahStream?.cancel();
    super.onClose();
  }
  
  Future<void> checkDeviceSupport() async {
    final deviceSupported = await FlutterQiblah.androidDeviceSensorSupport();
    isDeviceSupported.value = deviceSupported ?? false;
    
    if (isDeviceSupported.value) {
      await requestPermissions();
    } else {
      errorMessage.value = 'Device sensors not supported';
    }
  }
  
  Future<void> requestPermissions() async {
    // Request location permission
    final locationStatus = await Permission.location.request();
    
    if (locationStatus.isGranted) {
      hasPermission.value = true;
      await startQiblahStream();
    } else if (locationStatus.isDenied) {
      errorMessage.value = 'Location permission denied';
      hasPermission.value = false;
    } else if (locationStatus.isPermanentlyDenied) {
      errorMessage.value = 'Location permission permanently denied';
      hasPermission.value = false;
      // Open app settings
      await openAppSettings();
    }
  }
  
  Future<void> startQiblahStream() async {
    try {
      // Get current location
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      // Start Qiblah stream
      _qiblahStream = FlutterQiblah.qiblahStream.listen((direction) {
        qiblaDirection.value = direction.qiblah;
      });
      
    } catch (e) {
      errorMessage.value = 'Error: $e';
      print('Qibla error: $e');
    }
  }
  
  Future<void> retry() async {
    errorMessage.value = '';
    await checkDeviceSupport();
  }
}
