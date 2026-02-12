import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/prayer_controller.dart';

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
        title: const Text('নামাজের সময়'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshPrayerTimes(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final prayerTimes = controller.todayPrayerTimes.value;
        if (prayerTimes == null) {
          return const Center(child: Text('নামাজের সময় লোড হচ্ছে...'));
        }

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current prayer card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Colors.white,
                      size: 48.sp,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'পরবর্তী নামাজ',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      controller.getNextPrayer(),
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              Text(
                'আজকের নামাজের সময়',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 16.h),

              // Prayer times list
              _buildPrayerTimeCard(
                  context, 'ফজর', prayerTimes.fajr, Icons.wb_twilight, 0),
              SizedBox(height: 12.h),
              _buildPrayerTimeCard(context, 'সূর্যোদয়', prayerTimes.sunrise,
                  Icons.wb_sunny, null),
              SizedBox(height: 12.h),
              _buildPrayerTimeCard(context, 'যোহর', prayerTimes.dhuhr,
                  Icons.wb_sunny_outlined, 1),
              SizedBox(height: 12.h),
              _buildPrayerTimeCard(
                  context, 'আসর', prayerTimes.asr, Icons.brightness_5, 2),
              SizedBox(height: 12.h),
              _buildPrayerTimeCard(context, 'মাগরিব', prayerTimes.maghrib,
                  Icons.brightness_6, 3),
              SizedBox(height: 12.h),
              _buildPrayerTimeCard(
                  context, 'এশা', prayerTimes.isha, Icons.nightlight, 4),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPrayerTimeCard(
    BuildContext context,
    String prayerName,
    String time,
    IconData icon,
    int? alarmIndex,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
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
                Text(
                  prayerName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
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
                activeColor: Theme.of(context).primaryColor,
              );
            }),
        ],
      ),
    );
  }
}
