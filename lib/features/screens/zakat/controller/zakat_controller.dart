import 'package:get/get.dart';
import '../../../../services/zakat_service.dart';

class ZakatController extends GetxController {
  final ZakatService _zakatService = Get.find();

  // Observable values for user inputs
  var goldValue = 0.0.obs;
  var silverValue = 0.0.obs;
  var cashValue = 0.0.obs;
  var bankSavings = 0.0.obs;
  var businessAssets = 0.0.obs;
  var debts = 0.0.obs;

  // Observable values for calculated results
  var totalAssets = 0.0.obs;
  var zakatPayable = 0.0.obs;

  // Nisab threshold (you can adjust this based on current gold/silver prices)
  final double nisabThreshold = 87.48; // grams of gold equivalent

  void calculateZakat() {
    totalAssets.value = _zakatService.calculateTotalAssets(
      gold: goldValue.value,
      silver: silverValue.value,
      cash: cashValue.value,
      bank: bankSavings.value,
      business: businessAssets.value,
      debts: debts.value,
    );

    zakatPayable.value = _zakatService.calculateZakat(totalAssets.value);
  }

  @override
  void onInit() {
    super.onInit();
  }
}
