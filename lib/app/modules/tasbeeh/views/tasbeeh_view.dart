import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/tasbeeh_controller.dart';

class TasbeehView extends StatefulWidget {
  const TasbeehView({super.key});

  @override
  State<TasbeehView> createState() => _TasbeehViewState();
}

class _TasbeehViewState extends State<TasbeehView> {
  late final TasbeehController controller;

  @override
  void initState() {
    super.initState();
    controller = TasbeehController();
    controller.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('তাসবিহ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _showHistorySheet(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.reset(),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.05),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(
                  controller.currentDhikr.value,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                )),
            SizedBox(height: 8.h),
            Obx(() => Text(
                  'লক্ষ্য: ${controller.targetCount.value}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey,
                      ),
                )),
            SizedBox(height: 40.h),

            // Counter Display
            GestureDetector(
              onTap: () => controller.increment(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 250.w,
                    height: 250.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                    ),
                  ),
                  Obx(() => Container(
                        width: 220.w,
                        height: 220.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).cardColor,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${controller.count.value}',
                                style: TextStyle(
                                  fontSize: 80.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Text(
                                'বার',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                      )),
                  // Progress indicator could be added here
                ],
              ),
            ),

            SizedBox(height: 40.h),

            // Lap Count
            Obx(() => Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'মোট চক্কর: ${controller.lapCount.value}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                )),

            const Spacer(),

            // Instructions
            Padding(
              padding: EdgeInsets.only(bottom: 40.h),
              child: Text(
                'গুনতে স্ক্রিনে ট্যাপ করুন',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHistorySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'তাসবিহ ইতিহাস',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () => controller.clearAllHistory(),
                  child: const Text('সব মুছুন',
                      style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: Obx(
                () => controller.history.isEmpty
                    ? const Center(child: Text('কোনো ইতিহাস পাওয়া যায়নি'))
                    : ListView.builder(
                        itemCount: controller.history.length,
                        itemBuilder: (context, index) {
                          final item = controller.history[index];
                          return ListTile(
                            title: Text(item.dhikr),
                            subtitle: Text(
                                '${item.count} বার - ${item.date.day}/${item.date.month}/${item.date.year}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.grey),
                              onPressed: () =>
                                  controller.deleteHistoryItem(index),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
