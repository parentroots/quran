import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late final SettingsController controller;

  @override
  void initState() {
    super.initState();
    controller = SettingsController();
    controller.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('সেটিংস'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App theme section
            Text(
              'থিম',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 12.h),
            Obx(() => SwitchListTile(
                  value: controller.isDarkMode.value,
                  onChanged: (value) => controller.toggleDarkMode(),
                  title: const Text('ডার্ক মোড'),
                  subtitle: const Text('অন্ধকার থিম সক্রিয় করুন'),
                  secondary: Icon(
                    controller.isDarkMode.value
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: Theme.of(context).primaryColor,
                  ),
                  activeColor: Theme.of(context).primaryColor,
                )),

            SizedBox(height: 24.h),

            // Font size section
            Text(
              'ফন্টের আকার',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16.h),

            // Arabic font size
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'আরবি টেক্সট',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 8.h),
                  Obx(() => Text(
                        'আকার: ${controller.arabicFontSize.value.toInt()}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      )),
                  Obx(() => Slider(
                        value: controller.arabicFontSize.value,
                        min: 20.0,
                        max: 40.0,
                        divisions: 20,
                        label:
                            controller.arabicFontSize.value.toInt().toString(),
                        onChanged: (value) =>
                            controller.updateArabicFontSize(value),
                        activeColor: Theme.of(context).primaryColor,
                      )),
                ],
              ),
            ),

            SizedBox(height: 12.h),

            // Translation font size
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'অনুবাদ টেক্সট',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 8.h),
                  Obx(() => Text(
                        'আকার: ${controller.translationFontSize.value.toInt()}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      )),
                  Obx(() => Slider(
                        value: controller.translationFontSize.value,
                        min: 12.0,
                        max: 24.0,
                        divisions: 12,
                        label: controller.translationFontSize.value
                            .toInt()
                            .toString(),
                        onChanged: (value) =>
                            controller.updateTranslationFontSize(value),
                        activeColor: Theme.of(context).primaryColor,
                      )),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // About section
            Text(
              'অ্যাপ সম্পর্কে',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 12.h),

            ListTile(
              leading: Icon(
                Icons.info_outline,
                color: Theme.of(context).primaryColor,
              ),
              title: const Text('সংস্করণ'),
              subtitle: const Text('1.0.0'),
              tileColor: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),

            SizedBox(height: 12.h),

            ListTile(
              leading: Icon(
                Icons.description_outlined,
                color: Theme.of(context).primaryColor,
              ),
              title: const Text('শর্তাবলী'),
              tileColor: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              onTap: () {
                // Navigate to terms
              },
            ),

            SizedBox(height: 12.h),

            ListTile(
              leading: Icon(
                Icons.privacy_tip_outlined,
                color: Theme.of(context).primaryColor,
              ),
              title: const Text('গোপনীয়তা নীতি'),
              tileColor: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              onTap: () {
                // Navigate to privacy policy
              },
            ),

            SizedBox(height: 24.h),

            // Data section
            Text(
              'ডেটা',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 12.h),

            ListTile(
              leading: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
              title: const Text('সব ডেটা মুছে ফেলুন'),
              subtitle:
                  const Text('সতর্কতা: এই কাজটি পূর্বাবস্থায় ফেরানো যাবে না'),
              tileColor: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              onTap: () => controller.clearAllData(),
            ),

            SizedBox(height: 32.h),

            // App info
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.mosque,
                    size: 48.sp,
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'ইসলামিক অ্যাপ',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.7),
                        ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'আল্লাহর নামে',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.color
                              ?.withOpacity(0.5),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
