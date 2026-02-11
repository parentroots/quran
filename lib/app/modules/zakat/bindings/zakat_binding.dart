import 'package:get/get.dart';
import '../controllers/zakat_controller.dart';

class ZakatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ZakatController>(() => ZakatController());
  }
}
