import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../componant/app_container.dart';
import '../../../../componant/app_text.dart';
import '../../../../utils/constant/app_colors.dart';
import '../../../../utils/constant/app_strings.dart';
import '../controller/home_controller.dart';
import '../widget/home_item_category_item_card.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  late final HomeController controller;

  @override
  void initState() {
    super.initState();
    controller = HomeController();
    controller.onInit();

    // Refresh last read whenever the tab changes to Home
    ever(controller.currentIndex, (_) => controller.loadLastRead());
  }


  final List<Map<String,dynamic>> memoryListSlider = [

    {
      'title':'Nicchoy allah mohan',
      'refference':'akdf;adf'

    }

  ];



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

              _buildDailyReminder(context),

              SizedBox(height: 24.h),

              // Continue Reading Card
              Obx(() {
                final lastRead = controller.lastRead.value;
                if (lastRead != null) {
                  return _buildContinueReadingCard(context, lastRead);
                }
                return _buildEmptyLastReadCard(context);
              }),

              SizedBox(height: 24.h),

              // Quick Access Features
              AppText(
                AppString.quickAccess,
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
            AppText(
              controller.getGreeting(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 4.h),
            AppText(
              AppString.assalamuAlaikum,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        AppContainer(
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
    return Obx(() {
      if (controller.reminderList.isEmpty) {
        return const SizedBox();
      }

      return Column(
        children: [

          /// SLIDER
          CarouselSlider.builder(

            itemCount: controller.reminderList.length,
            itemBuilder: (context, index, realIndex) {

              final data = controller.reminderList[index];

              return AppContainer(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context)
                          .primaryColor
                          .withValues(alpha: 0.7),
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
                        AppText(
                          AppString.dailyReminder,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),

                    SizedBox(height: 12.h),

                    AppText(
                      data["title"] ?? "",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    AppText(
                      data["reference"] ?? "",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              );
            },
            options: CarouselOptions(
              aspectRatio:16/9,
              height: 140.h,
              autoPlay: true,
              enlargeCenterPage: false,
              viewportFraction: 1,

              onPageChanged: (index, reason) {
                controller.currentReminderIndex.value = index;
              },
            ),
          ),

          SizedBox(height: 12.h),

          /// INDICATOR
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              controller.reminderList.length,
                  (index) => Obx(() {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  width: controller.currentReminderIndex.value == index
                      ? 16.w
                      : 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: controller.currentReminderIndex.value == index
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildEmptyLastReadCard(BuildContext context) {
    return AppContainer(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          AppContainer(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.menu_book_outlined,
              color: Theme.of(context).primaryColor,
              size: 32.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  AppString.noReadYet,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                AppText(
                  AppString.startReadingDesc,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => controller.changeTab(1),
            icon: Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: Theme.of(context).primaryColor,
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
      child: AppContainer(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withValues(alpha: 0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                Icons.menu_book,
                size: 100.sp,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            Row(
              children: [
                AppContainer(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
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
                      Row(
                        children: [
                          Icon(Icons.history,
                              color: Colors.white70, size: 14.sp),
                          SizedBox(width: 4.w),
                          AppText(
                            AppString.lastReadSmall,
                            style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      AppText(
                        lastRead.surahName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      AppText(
                        '${AppString.ayahNo} ${lastRead.ayahNumber}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                AppContainer(
                  padding: EdgeInsets.all(8.w),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    color: Theme.of(context).primaryColor,
                    size: 20.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context,) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16.w,
      mainAxisSpacing: 16.h,
      childAspectRatio: 1.3,
      children: [
        buildFeatureCard(
          context,
          imagePath: 'assets/images/quran.png',
          title: AppString.quran,
          color: Colors.green,
          onTap: () => Get.toNamed('/quran'),
        ),
        buildFeatureCard(
          context,
          icon: Icons.article,
          title: AppString.hadith,
          color: Colors.blue,
          onTap: () => Get.toNamed('/hadith'),
        ),
        buildFeatureCard(
          context,
          imagePath: 'assets/images/compass.png',
          title: 'কিবলা',
          color: Colors.orange,
          onTap: () => Get.toNamed('/qibla'),
        ),
        buildFeatureCard(
          context,
          imagePath: 'assets/images/paryer_time.png',
          title: AppString.prayerTime,
          color: Colors.purple,
          onTap: () => Get.toNamed('/prayer'),
        ),
        buildFeatureCard(
          context,
          imagePath: 'assets/images/tasbih.png',
          title: AppString.tasbeeh,
          color: Colors.teal,
          onTap: () => Get.toNamed('/tasbeeh'),
        ),
        buildFeatureCard(
          context,
          imagePath: 'assets/images/dua.png',
          title: AppString.duaAndAzkar,
          color: Colors.pink,
          onTap: () => Get.toNamed('/dua'),
        ),
        buildFeatureCard(
          context,
          icon: Icons.calculate,
          title: AppString.zakat,
          color: Colors.brown,
          onTap: () => Get.toNamed('/zakat'),
        ),
        buildFeatureCard(
          context,
          icon: Icons.auto_awesome,
          title: AppString.names99,
          color: Colors.amber,
          onTap: () => Get.toNamed('/names'),
        ),
        buildFeatureCard(
          context,
          icon: Icons.calendar_month,
          title: AppString.hijri,
          color: Colors.deepPurple,
          onTap: () => Get.toNamed('/calendar'),
        ),
      ],
    );
  }


}
