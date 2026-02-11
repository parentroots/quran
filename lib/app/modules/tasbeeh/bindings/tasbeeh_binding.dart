import 'package:get/get.dart';
import '../controllers/tasbeeh_controller.dart';

class TasbeehBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TasbeehController>(() => TasbeehController());
  }
}
