import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controller/settings_controller.dart';
import '../../../../componant/app_container.dart';
import '../../../../componant/app_text.dart';
import '../../../../componant/custom_header.dart';
import '../../../../utils/constant/app_strings.dart';

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
        title: const AppText(AppString.settingsTitle),
      ),
      body: Column(
        children: [
          const CustomHeader(
            title: AppString.settingsTitle,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App theme section
                  AppText(
                    AppString.theme,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 12.h),
                  Obx(() => SwitchListTile(
                        value: controller.isDarkMode.value,
                        onChanged: (value) => controller.toggleDarkMode(),
                        title: const AppText(AppString.darkMode),
                        subtitle: const AppText(AppString.enableDarkMode),
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
                  AppText(
                    AppString.fontSize,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 16.h),

                  // Arabic font size
                  AppContainer(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          AppString.arabicText,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 8.h),
                        Obx(() => AppText(
                              '${AppString.size}: ${controller.arabicFontSize.value.toInt()}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            )),
                        Obx(() => Slider(
                              value: controller.arabicFontSize.value,
                              min: 20.0,
                              max: 40.0,
                              divisions: 20,
                              label: controller.arabicFontSize.value
                                  .toInt()
                                  .toString(),
                              onChanged: (value) =>
                                  controller.updateArabicFontSize(value),
                              activeColor: Theme.of(context).primaryColor,
                            )),
                      ],
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Translation font size
                  AppContainer(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          AppString.translationText,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 8.h),
                        Obx(() => AppText(
                              '${AppString.size}: ${controller.translationFontSize.value.toInt()}',
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
                  AppText(
                    AppString.aboutApp,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 12.h),

                  ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: const AppText(AppString.version),
                    subtitle: const AppText('1.0.0'),
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
                    title: const AppText(AppString.terms),
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
                    title: const AppText(AppString.privacyPolicy),
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
                  AppText(
                    AppString.data,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 12.h),

                  ListTile(
                    leading: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    title: const AppText(AppString.clearAllData),
                    subtitle: const AppText(AppString.clearDataWarning),
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
                          color: Theme.of(context)
                              .primaryColor
                              .withValues(alpha: 0.5),
                        ),
                        SizedBox(height: 8.h),
                        AppText(
                          AppString.appName,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withValues(alpha: 0.7),
                                  ),
                        ),
                        SizedBox(height: 4.h),
                        AppText(
                          AppString.inTheNameOfAllah,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color
                                        ?.withValues(alpha: 0.5),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
