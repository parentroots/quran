import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controller/home_controller.dart';
import '../../quran/view/quran_view.dart';
import '../../hadith/view/hadith_view.dart';
import '../../prayer/view/prayer_view.dart';
import '../../settings/view/settings_view.dart';
import '../../../../componant/app_container.dart';
import '../../../../componant/app_text.dart';

import '../../../../utils/constant/app_strings.dart';
import 'home_dashboard.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeController controller;

  @override
  void initState() {
    super.initState();
    controller = HomeController();
    controller.onInit();
  }

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
    return AppContainer(
      height: 70.h,
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AppContainer(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(context, 0, Icons.home_outlined, Icons.home,
                    AppString.home),
                _buildNavItem(context, 1, Icons.menu_book_outlined,
                    Icons.menu_book, AppString.quran),
                _buildNavItem(context, 2, Icons.article_outlined, Icons.article,
                    AppString.hadith),
                _buildNavItem(context, 3, Icons.access_time_outlined,
                    Icons.access_time, AppString.prayer),
                _buildNavItem(context, 4, Icons.settings_outlined,
                    Icons.settings, AppString.settings),
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
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
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
              AppText(
                label,
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
                color: color,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

