import 'package:get/get.dart';
import '../controllers/quran_controller.dart';
import '../../../services/api_service.dart';

class QuranBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuranController>(() => QuranController());
  }
}
