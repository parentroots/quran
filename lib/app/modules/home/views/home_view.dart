import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/home_controller.dart';
import '../../quran/views/quran_view.dart';
import '../../hadith/views/hadith_view.dart';
import '../../qibla/views/qibla_view.dart';
import '../../prayer/views/prayer_view.dart';
import '../../settings/views/settings_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        extendBody:
            true, // This allows the Scaffold to extend behind the bottom nav
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            HomeDashboard(),
            QuranView(),
            HadithView(),
            PrayerView(),
            SettingsView(),
          ],
        ),
        bottomNavigationBar: _buildCustomBottomNav(context),
      );
    });
  }

  Widget _buildCustomBottomNav(BuildContext context) {
    return Container(
      height: 70.h,
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withOpacity(0.7),
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                    context, 0, Icons.home_outlined, Icons.home, 'হোম'),
                _buildNavItem(context, 1, Icons.menu_book_outlined,
                    Icons.menu_book, 'কুরআন'),
                _buildNavItem(
                    context, 2, Icons.article_outlined, Icons.article, 'হাদিস'),
                _buildNavItem(context, 3, Icons.access_time_outlined,
                    Icons.access_time, 'নামাজ'),
                _buildNavItem(context, 4, Icons.settings_outlined,
                    Icons.settings, 'সেটিংস'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon,
      IconData activeIcon, String label) {
    final isSelected = controller.currentIndex.value == index;
    final color = isSelected ? Theme.of(context).primaryColor : Colors.grey;

    return GestureDetector(
      onTap: () => controller.changeTab(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: color,
              size: 24.sp,
            ),
            if (isSelected) ...[
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class HomeDashboard extends GetView<HomeController> {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(context),

              SizedBox(height: 24.h),

              // Daily Reminder (Now on Top)
              _buildDailyReminder(context),

              SizedBox(height: 24.h),

              // Continue Reading Card
              Obx(() {
                final lastRead = controller.lastRead.value;
                if (lastRead != null) {
                  return _buildContinueReadingCard(context, lastRead);
                }
                return const SizedBox.shrink();
              }),

              SizedBox(height: 24.h),

              // Quick Access Features
              Text(
                'দ্রুত অ্যাক্সেস',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 16.h),

              _buildFeatureGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.getGreeting(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 4.h),
            Text(
              'আসসালামু আলাইকুম',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.notifications_outlined,
            color: Theme.of(context).primaryColor,
            size: 24.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildDailyReminder(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.wb_sunny_outlined,
                color: Colors.white,
                size: 32.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                'আজকের স্মরণীয়',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'নিশ্চয়ই আল্লাহর স্মরণেই অন্তর প্রশান্ত হয়।',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
          ),
          SizedBox(height: 8.h),
          Text(
            'সূরা আর-রাদ (১৩:২৮)',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueReadingCard(BuildContext context, dynamic lastRead) {
    return GestureDetector(
      onTap: () {
        final surah = controller.getSurah(lastRead.surahNumber);
        if (surah != null) {
          Get.toNamed('/surah-detail', arguments: {
            'surah': surah,
            'scrollToAyah': lastRead.ayahNumber,
          });
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.secondary.withOpacity(0.7),
            ],
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.bookmark,
                color: Colors.white,
                size: 32.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'শেষ পাঠ',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    lastRead.surahName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'আয়াত ${lastRead.ayahNumber}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16.w,
      mainAxisSpacing: 16.h,
      childAspectRatio: 1.3,
      children: [
        _buildFeatureCard(
          context,
          imagePath: 'assets/images/quran.png',
          title: 'কুরআন',
          color: Colors.green,
          onTap: () => Get.toNamed('/quran'),
        ),
        _buildFeatureCard(
          context,
          icon: Icons.article,
          title: 'হাদিস',
          color: Colors.blue,
          onTap: () => Get.toNamed('/hadith'),
        ),
        _buildFeatureCard(
          context,
          imagePath: 'assets/images/compass.png',
          title: 'কিবলা',
          color: Colors.orange,
          onTap: () => Get.toNamed('/qibla'),
        ),
        _buildFeatureCard(
          context,
          imagePath: 'assets/images/paryer_time.png',
          title: 'নামাজের সময়',
          color: Colors.purple,
          onTap: () => Get.toNamed('/prayer'),
        ),
        _buildFeatureCard(
          context,
          imagePath: 'assets/images/tasbih.png',
          title: 'তাসবিহ',
          color: Colors.teal,
          onTap: () => Get.toNamed('/tasbeeh'),
        ),
        _buildFeatureCard(
          context,
          imagePath: 'assets/images/dua.png',
          title: 'দুয়া ও আজকার',
          color: Colors.pink,
          onTap: () => Get.toNamed('/dua'),
        ),
        _buildFeatureCard(
          context,
          icon: Icons.calculate,
          title: 'যাকাত',
          color: Colors.brown,
          onTap: () => Get.toNamed('/zakat'),
        ),
        _buildFeatureCard(
          context,
          icon: Icons.auto_awesome,
          title: '৯৯ নাম',
          color: Colors.amber,
          onTap: () => Get.toNamed('/names'),
        ),
        _buildFeatureCard(
          context,
          icon: Icons.calendar_month,
          title: 'হিজরি',
          color: Colors.deepPurple,
          onTap: () => Get.toNamed('/calendar'),
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    IconData? icon,
    String? imagePath,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: imagePath != null
                  ? Image.asset(
                      imagePath,
                      width: 40.w,
                      height: 40.w,
                      fit: BoxFit.contain,
                    )
                  : Icon(
                      icon,
                      color: color,
                      size: 32.sp,
                    ),
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
