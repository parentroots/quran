import 'package:get/get.dart';
import '../routes/app_route_names.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _startNavigationTimer();
  }

  void _startNavigationTimer() {
    // 3 seconds delay for splash animation
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed(AppRouteNames.home);
    });
  }
}
