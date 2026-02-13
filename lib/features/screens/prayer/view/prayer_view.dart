import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controller/prayer_controller.dart';
import '../../../../componant/app_container.dart';
import '../../../../componant/app_text.dart';
import '../../../../componant/custom_header.dart';
import '../../../../utils/constant/app_strings.dart';

class PrayerView extends StatefulWidget {
  const PrayerView({super.key});

  @override
  State<PrayerView> createState() => _PrayerViewState();
}

class _PrayerViewState extends State<PrayerView> {
  late final PrayerController controller;

  @override
  void initState() {
    super.initState();
    controller = PrayerController();
    controller.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(AppString.prayerTimesTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshPrayerTimes(),
          ),
        ],
      ),
      body: Column(
        children: [
          Obx(() {
            final prayerTimes = controller.todayPrayerTimes.value;
            if (prayerTimes == null) return const SizedBox.shrink();
            return CustomHeader(
              title: AppString.nextPrayer,
              subtitle: AppText(
                controller.getNextPrayer(),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            );
          }),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final prayerTimes = controller.todayPrayerTimes.value;
              if (prayerTimes == null) {
                return const Center(
                    child: AppText(AppString.loadingPrayerTimes));
              }

              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      AppString.todayPrayerTimes,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 16.h),

                    // Prayer times list
                    _buildPrayerTimeCard(context, AppString.fajr,
                        prayerTimes.fajr, Icons.wb_twilight, 0),
                    SizedBox(height: 12.h),
                    _buildPrayerTimeCard(context, AppString.sunrise,
                        prayerTimes.sunrise, Icons.wb_sunny, null),
                    SizedBox(height: 12.h),
                    _buildPrayerTimeCard(context, AppString.dhuhr,
                        prayerTimes.dhuhr, Icons.wb_sunny_outlined, 1),
                    SizedBox(height: 12.h),
                    _buildPrayerTimeCard(context, AppString.asr,
                        prayerTimes.asr, Icons.brightness_5, 2),
                    SizedBox(height: 12.h),
                    _buildPrayerTimeCard(context, AppString.maghrib,
                        prayerTimes.maghrib, Icons.brightness_6, 3),
                    SizedBox(height: 12.h),
                    _buildPrayerTimeCard(context, AppString.isha,
                        prayerTimes.isha, Icons.nightlight, 4),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerTimeCard(
    BuildContext context,
    String prayerName,
    String time,
    IconData icon,
    int? alarmIndex,
  ) {
    return AppContainer(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          AppContainer(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 28.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  prayerName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                AppText(
                  time,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          if (alarmIndex != null)
            Obx(() {
              final isEnabled = controller.alarms.length > alarmIndex
                  ? controller.alarms[alarmIndex].isEnabled
                  : false;

              return Switch(
                value: isEnabled,
                onChanged: (value) {
                  if (controller.alarms.length > alarmIndex) {
                    controller.toggleAlarm(alarmIndex);
                  }
                },
                activeThumbColor: Theme.of(context).primaryColor,
              );
            }),
        ],
      ),
    );
  }
}
