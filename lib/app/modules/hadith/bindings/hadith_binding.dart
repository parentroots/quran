import 'package:get/get.dart';
import '../controllers/hadith_controller.dart';
import '../../../services/api_service.dart';

class HadithBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HadithController>(() => HadithController());
  }
}
