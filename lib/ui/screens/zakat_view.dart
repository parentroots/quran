import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../controllers/zakat_controller.dart';
import '../widgets/app_text.dart';
import '../widgets/app_container.dart';
import '../widgets/app_button.dart';
import '../widgets/custom_header.dart';
import '../../utils/app_strings.dart';

class ZakatView extends StatefulWidget {
  const ZakatView({super.key});

  @override
  State<ZakatView> createState() => _ZakatViewState();
}

class _ZakatViewState extends State<ZakatView> {
  late final ZakatController controller;

  @override
  void initState() {
    super.initState();
    controller = ZakatController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(AppString.zakatTitle),
      ),
      body: Column(
        children: [
          CustomHeader(
            title: AppString.assetCalculation,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputField(
                    AppString.goldValue,
                    (val) =>
                        controller.goldValue.value = double.tryParse(val) ?? 0,
                  ),
                  _buildInputField(
                    AppString.silverValue,
                    (val) => controller.silverValue.value =
                        double.tryParse(val) ?? 0,
                  ),
                  _buildInputField(
                    AppString.cashAmount,
                    (val) =>
                        controller.cashValue.value = double.tryParse(val) ?? 0,
                  ),
                  _buildInputField(
                    AppString.bankSavings,
                    (val) => controller.bankSavings.value =
                        double.tryParse(val) ?? 0,
                  ),
                  _buildInputField(
                    AppString.businessAssets,
                    (val) => controller.businessAssets.value =
                        double.tryParse(val) ?? 0,
                  ),
                  _buildInputField(
                    AppString.debts,
                    (val) => controller.debts.value = double.tryParse(val) ?? 0,
                    isDebt: true,
                  ),
                  SizedBox(height: 30.h),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      text: AppString.calculate,
                      onPressed: () => controller.calculateZakat(),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Obx(() => controller.totalAssets.value > 0
                      ? _buildResultCard(context)
                      : const SizedBox.shrink()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, Function(String) onChanged,
      {bool isDebt = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: TextField(
        keyboardType: TextInputType.number,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            isDebt ? Icons.remove_circle_outline : Icons.add_circle_outline,
            color: isDebt ? Colors.red : Colors.green,
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(BuildContext context) {
    return AppContainer(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Theme.of(context).primaryColor, width: 2),
      ),
      child: Column(
        children: [
          AppText(
            AppString.totalZakatAssets,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          AppText(
            '৳ ${controller.totalAssets.value.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
          ),
          SizedBox(height: 16.h),
          const Divider(),
          SizedBox(height: 16.h),
          AppText(
            AppString.payableZakat,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          AppText(
            '৳ ${controller.zakatPayable.value.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
          ),
        ],
      ),
    );
  }
}
