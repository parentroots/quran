class ZakatService {
  // Singleton Pattern
  static final ZakatService _instance = ZakatService._internal();
  factory ZakatService() => _instance;
  ZakatService._internal();

  Future<ZakatService> init() async {
    return this;
  }

  double calculateZakat(double totalAssets) {
    if (totalAssets > 0) {
      return totalAssets * 0.025;
    }
    return 0.0;
  }

  double calculateTotalAssets({
    required double gold,
    required double silver,
    required double cash,
    required double bank,
    required double business,
    required double debts,
  }) {
    return gold + silver + cash + bank + business - debts;
  }
}
