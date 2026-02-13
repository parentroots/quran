import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../controller/quran_controller.dart';
import '../data/quran_model.dart';
import '../../../../utils/constant/app_strings.dart';
import '../../../../componant/app_container.dart';
import '../../../../componant/app_text.dart';
import '../../../../componant/custom_header.dart';

class SurahDetailView extends StatefulWidget {
  const SurahDetailView({super.key});

  @override
  State<SurahDetailView> createState() => _SurahDetailViewState();
}

class _SurahDetailViewState extends State<SurahDetailView> {
  late final QuranController controller;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
    controller = QuranController();
    controller.onInit();

    // Move initialization logic here to avoid redundant execution in build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final Surah surah = Get.arguments['surah'];
      final int? scrollToAyah = Get.arguments['scrollToAyah'];

      await controller.loadSurahAyahs(surah);

      if (scrollToAyah != null && scrollToAyah > 0) {
        // Delay slightly to ensure the list is rendered
        Future.delayed(const Duration(milliseconds: 300), () {
          if (itemScrollController.isAttached) {
            itemScrollController.scrollTo(
              index: scrollToAyah,
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOutCubic,
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Surah surah = Get.arguments['surah'];

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          CustomHeader(
            title: surah.englishName,
            subtitle: AppText(
              surah.name,
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 20.sp,
                color: Colors.white70,
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoadingAyahs.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.currentAyahs.isEmpty) {
                return const Center(child: AppText(AppString.loadingAyahs));
              }

              return ScrollablePositionedList.builder(
                itemScrollController: itemScrollController,
                itemPositionsListener: itemPositionsListener,
                padding: EdgeInsets.all(16.w),
                itemCount: controller.currentAyahs.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildSurahHeader(context, surah);
                  }

                  final ayah = controller.currentAyahs[index - 1];
                  return _buildAyahCard(context, ayah);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahHeader(BuildContext context, Surah surah) {
    return AppContainer(
      margin: EdgeInsets.only(bottom: 24.h),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          AppText(
            surah.name,
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          AppText(
            surah.englishNameTranslation,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
          SizedBox(height: 8.h),
          AppContainer(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: AppText(
              '${surah.revelationType} • ${surah.numberOfAyahs} ${AppString.ayah}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
          SizedBox(height: 16.h),
          if (surah.number != 1 && surah.number != 9)
            AppText(
              AppString.bismillah,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 24.sp,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAyahCard(BuildContext context, Ayah ayah) {
    return GestureDetector(
      onTap: () {
        controller.saveLastRead(ayah.numberInSurah);
        Get.snackbar(
          AppString.saved,
          AppString.lastReadSaved,
          duration: const Duration(seconds: 2),
        );
      },
      child: AppContainer(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.blue,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ayah number
            AppContainer(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: AppText(
                '${AppString.ayah} ${ayah.numberInSurah}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            SizedBox(height: 16.h),

            // Arabic text
            AppText(
              ayah.text,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 28.sp,
                height: 2.0,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            SizedBox(height: 16.h),

            // Transliteration (pronunciation)
            if (ayah.transliteration != null &&
                ayah.transliteration!.isNotEmpty)
              AppText(
               "উচ্চারন : ${ ayah.transliteration!}",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      color: Theme.of(context).primaryColor,
                    ),
              ),

            if (ayah.transliteration != null &&
                ayah.transliteration!.isNotEmpty)
              SizedBox(height: 12.h),

            // Translation
            if (ayah.translation != null && ayah.translation!.isNotEmpty)
              AppText("বাংলা অর্থ : ${ayah.translation!}",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                    ),
              ),

            SizedBox(height: 12.h),

            // Action buttons
            Row(
              children: [
                _buildActionButton(
                  context,
                  icon: Icons.bookmark_outline,
                  onTap: () => controller.saveLastRead(ayah.numberInSurah),
                  label: AppString.save,
                ),
                const Spacer(),
                Obx(() {
                  final bool isPlaying = controller.isPlaying.value &&
                      controller.playingAyahNumber.value == ayah.numberInSurah;
                  return _buildRecitationButton(context, isPlaying, ayah);
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
    String? label,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: AppContainer(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20.sp,
              color: Theme.of(context).primaryColor,
            ),
            if (label != null) ...[
              SizedBox(width: 8.w),
              AppText(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRecitationButton(
      BuildContext context, bool isPlaying, Ayah ayah) {
    return InkWell(
      onTap: () => controller.speakAyah(ayah),
      borderRadius: BorderRadius.circular(30.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isPlaying
              ? Colors.red.withValues(alpha: 0.1)
              : Theme.of(context).primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(
            color: isPlaying ? Colors.red : Theme.of(context).primaryColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
              size: 20.sp,
              color: isPlaying ? Colors.red : Theme.of(context).primaryColor,
            ),
            SizedBox(width: 8.w),
            AppText(
              isPlaying ? AppString.stop : AppString.listen,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: isPlaying ? Colors.red : Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
