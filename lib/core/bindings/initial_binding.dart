import 'package:get/get.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Services are already initialized in main.dart
    // This ensures they're available throughout the app
    Get.lazyPut<StorageService>(() => Get.find<StorageService>());
    Get.lazyPut<NotificationService>(() => Get.find<NotificationService>());
  }
}
