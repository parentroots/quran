import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../controllers/dua_controller.dart';
import '../../utils/app_strings.dart';
import '../widgets/custom_header.dart';
import '../widgets/app_text.dart';

class DuaView extends StatefulWidget {
  const DuaView({super.key});

  @override
  State<DuaView> createState() => _DuaViewState();
}

class _DuaViewState extends State<DuaView> {
  late final DuaController controller;

  @override
  void initState() {
    super.initState();
    controller = DuaController();
    controller.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(AppString.duaAndAzkar),
      ),
      body: Column(
        children: [
          const CustomHeader(
            title: AppString.duaAndAzkar,
          ),
          // Category selector
          Container(
            height: 60.h,
            margin: EdgeInsets.symmetric(vertical: 16.h),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: controller.categories.length,
              itemBuilder: (context, index) {
                final category = controller.categories[index];
                return Obx(() {
                  final isSelected =
                      controller.selectedCategory.value == category.name;
                  return GestureDetector(
                    onTap: () => controller.filterByCategory(category.name),
                    child: Container(
                      margin: EdgeInsets.only(right: 12.w),
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            AppText(category.icon,
                                style: TextStyle(fontSize: 18.sp)),
                            SizedBox(width: 8.w),
                            AppText(
                              category.name,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),

          // Dua List
          Expanded(
            child: Obx(() {
              if (controller.filteredDuas.isEmpty) {
                return const Center(child: AppText('কোন দোয়া পাওয়া যায়নি'));
              }
              return ListView.builder(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 100.h),
                itemCount: controller.filteredDuas.length,
                itemBuilder: (context, index) {
                  final dua = controller.filteredDuas[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          dua.title,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                        ),
                        SizedBox(height: 16.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: AppText(
                            dua.arabic,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Amiri',
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        AppText(
                          dua.transliteration,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey[700],
                                  ),
                        ),
                        SizedBox(height: 12.h),
                        AppText(
                          dua.translation,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        SizedBox(height: 12.h),
                        Divider(color: Colors.grey.withOpacity(0.2)),
                        AppText(
                          dua.reference,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey,
                                  ),
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
