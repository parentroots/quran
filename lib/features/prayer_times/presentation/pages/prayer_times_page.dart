import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/prayer_times_controller.dart';
import '../../../../core/config/theme.dart';

class PrayerTimesPage extends GetView<PrayerTimesController> {
  const PrayerTimesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Times'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.loadPrayerTimes,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        return SingleChildScrollView(
          child: Column(
            children: [
              // Current Prayer Card
              _buildCurrentPrayerCard(context),
              
              const SizedBox(height: 16),
              
              // Prayer Times List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.prayers.length,
                itemBuilder: (context, index) {
                  final prayer = controller.prayers[index];
                  final time = controller.prayerTimes[prayer] ?? '';
                  return _buildPrayerTimeCard(context, prayer, time);
                },
              ),
              
              const SizedBox(height: 80),
            ],
          ),
        );
      }),
    );
  }
  
  Widget _buildCurrentPrayerCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryGreen, AppTheme.secondaryTeal],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Next Prayer',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Obx(() => Text(
            controller.nextPrayer.value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          )),
          const SizedBox(height: 4),
          Obx(() => Text(
            controller.prayerTimes[controller.nextPrayer.value] ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          )),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.timer_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Obx(() => Text(
                  'in ${controller.timeUntilNext.value}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPrayerTimeCard(BuildContext context, String prayer, String time) {
    final isCurrent = controller.currentPrayer.value == prayer;
    final isNext = controller.nextPrayer.value == prayer;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isCurrent
          ? AppTheme.primaryGreen.withOpacity(0.1)
          : isNext
              ? AppTheme.primaryGold.withOpacity(0.1)
              : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Prayer Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isCurrent
                    ? AppTheme.primaryGreen
                    : isNext
                        ? AppTheme.primaryGold
                        : AppTheme.secondaryTeal.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getPrayerIcon(prayer),
                color: isCurrent || isNext ? Colors.white : AppTheme.secondaryTeal,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            
            // Prayer Name and Time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        prayer,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: isCurrent || isNext
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      if (isCurrent)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGreen,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Current',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (isNext)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGold,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Next',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isCurrent || isNext
                          ? AppTheme.primaryGreen
                          : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            
            // Alarm Toggle
            Obx(() {
              final isEnabled = controller.isPrayerAlarmEnabled(prayer);
              return Switch(
                value: isEnabled,
                onChanged: (value) {
                  controller.togglePrayerAlarm(prayer, value);
                },
                activeColor: AppTheme.primaryGreen,
              );
            }),
          ],
        ),
      ),
    );
  }
  
  IconData _getPrayerIcon(String prayer) {
    switch (prayer) {
      case 'Fajr':
        return Icons.wb_twilight;
      case 'Dhuhr':
        return Icons.wb_sunny;
      case 'Asr':
        return Icons.wb_sunny_outlined;
      case 'Maghrib':
        return Icons.wb_twilight;
      case 'Isha':
        return Icons.nightlight_round;
      default:
        return Icons.access_time;
    }
  }
}
