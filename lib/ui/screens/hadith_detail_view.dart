import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../controllers/hadith_controller.dart';
import '../../core/models/hadith_model.dart';
import '../widgets/app_text.dart';
import '../widgets/app_container.dart';
import '../widgets/custom_header.dart';
import '../../utils/app_strings.dart';

class HadithDetailView extends StatefulWidget {
  const HadithDetailView({super.key});

  @override
  State<HadithDetailView> createState() => _HadithDetailViewState();
}

class _HadithDetailViewState extends State<HadithDetailView> {
  late final HadithController controller;

  @override
  void initState() {
    super.initState();
    controller = HadithController();
    controller.onInit();
  }

  @override
  Widget build(BuildContext context) {
    final HadithBook book = Get.arguments['book'];

    // Load hadiths when view is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadHadiths(book);
    });

    return Scaffold(
      appBar: AppBar(
        title: AppText(book.name),
      ),
      body: Column(
        children: [
          CustomHeader(
            title: book.name,
            subtitle: AppText(
              book.writerName,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white70,
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoadingHadiths.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.currentHadiths.isEmpty) {
                return const Center(
                    child: AppText(AppString.noHadithsFoundInBook));
              }

              return ListView.separated(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
                itemCount: controller.currentHadiths.length,
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  final hadith = controller.currentHadiths[index];
                  return AppContainer(
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
                        Row(
                          children: [
                            AppContainer(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: AppText(
                                '${AppString.hadithCount} ${hadith.hadithNumber}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            const Spacer(),
                            if (hadith.category != null)
                              AppContainer(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: AppText(
                                  hadith.category!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        AppText(
                          hadith.text,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    height: 1.6,
                                  ),
                        ),
                        SizedBox(height: 12.h),
                        Divider(color: Theme.of(context).dividerColor),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 16.sp,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(width: 8.w),
                            AppText(
                              '${AppString.narrator}: ${hadith.narrator}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.share_outlined),
                              iconSize: 20.sp,
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                // Share functionality
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.bookmark_outline),
                              iconSize: 20.sp,
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                // Bookmark functionality
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
