import 'package:get/get.dart';

class ZakatController extends GetxController {
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
    // Calculate total assets
    double total = goldValue.value +
        silverValue.value +
        cashValue.value +
        bankSavings.value +
        businessAssets.value -
        debts.value;

    totalAssets.value = total;

    // Calculate zakat (2.5% of total assets if above nisab)
    if (total > 0) {
      zakatPayable.value = total * 0.025;
    } else {
      zakatPayable.value = 0.0;
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize any default values if needed
  }
}
