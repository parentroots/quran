import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../controllers/quran_controller.dart';
import '../../../data/models/quran_model.dart';

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
      appBar: AppBar(
        title: Column(
          children: [
            Text(surah.englishName),
            Text(
              surah.name,
              style: const TextStyle(fontFamily: 'Amiri', fontSize: 18),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoadingAyahs.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.currentAyahs.isEmpty) {
          return const Center(child: Text('আয়াত লোড হচ্ছে...'));
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
    );
  }

  Widget _buildSurahHeader(BuildContext context, Surah surah) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
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
          Text(
            surah.name,
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            surah.englishNameTranslation,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              '${surah.revelationType} • ${surah.numberOfAyahs} আয়াত',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
          SizedBox(height: 16.h),
          if (surah.number != 1 && surah.number != 9)
            Text(
              'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
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
          'সংরক্ষিত',
          'শেষ পাঠ সংরক্ষণ করা হয়েছে',
          duration: const Duration(seconds: 2),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ayah number
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'আয়াত ${ayah.numberInSurah}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            SizedBox(height: 16.h),

            // Arabic text
            Text(
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

            // Translation
            if (ayah.translation != null && ayah.translation!.isNotEmpty)
              Text(
                ayah.translation!,
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
                  label: 'সংরক্ষণ',
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
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.05),
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
              Text(
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
              ? Colors.red.withOpacity(0.1)
              : Theme.of(context).primaryColor.withOpacity(0.1),
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
            Text(
              isPlaying ? 'থামান' : 'শুনুন',
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
