import 'package:get/get.dart';
import '../controllers/names_controller.dart';

class NamesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NamesController>(() => NamesController());
  }
}
