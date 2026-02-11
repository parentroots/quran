import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/zakat_controller.dart';

class ZakatView extends GetView<ZakatController> {
  const ZakatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('যাকাত ক্যালকুলেটর'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'আপনার সম্পদের হিসাব দিন',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            SizedBox(height: 20.h),
            _buildInputField(
              'স্বর্ণের মূল্য',
              (val) => controller.goldValue.value = double.tryParse(val) ?? 0,
            ),
            _buildInputField(
              'রুপার মূল্য',
              (val) => controller.silverValue.value = double.tryParse(val) ?? 0,
            ),
            _buildInputField(
              'নগদ টাকা',
              (val) => controller.cashValue.value = double.tryParse(val) ?? 0,
            ),
            _buildInputField(
              'ব্যাংকে জমানো টাকা',
              (val) => controller.bankSavings.value = double.tryParse(val) ?? 0,
            ),
            _buildInputField(
              'ব্যবসায়িক সম্পদ',
              (val) =>
                  controller.businessAssets.value = double.tryParse(val) ?? 0,
            ),
            _buildInputField(
              'ঋণ (বিয়োগ হবে)',
              (val) => controller.debts.value = double.tryParse(val) ?? 0,
              isDebt: true,
            ),
            SizedBox(height: 30.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.calculateZakat(),
                child: const Text('হিসাব করুন'),
              ),
            ),
            SizedBox(height: 30.h),
            Obx(() => controller.totalAssets.value > 0
                ? _buildResultCard(context)
                : const SizedBox.shrink()),
          ],
        ),
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
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Theme.of(context).primaryColor, width: 2),
      ),
      child: Column(
        children: [
          Text(
            'মোট যাকাতযোগ্য সম্পদ',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            '৳ ${controller.totalAssets.value.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
          ),
          SizedBox(height: 16.h),
          const Divider(),
          SizedBox(height: 16.h),
          Text(
            'প্রদেয় যাকাত (২.৫%)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
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
