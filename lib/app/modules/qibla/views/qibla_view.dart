import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/qibla_controller.dart';

class QiblaView extends GetView<QiblaController> {
  const QiblaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('কিবলার দিক'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshLocation(),
          ),
        ],
      ),
      body: Obx(() {
        if (!controller.hasPermission.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_off, size: 64.sp, color: Colors.grey),
                SizedBox(height: 16.h),
                const Text('অবস্থান অনুমতি প্রয়োজন'),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () => controller.checkPermissions(),
                  child: const Text('অনুমতি দিন'),
                ),
              ],
            ),
          );
        }

        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            SizedBox(height: 32.h),
            
            // Location info
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'আপনার অবস্থান',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '${controller.userLatitude.value.toStringAsFixed(4)}, ${controller.userLongitude.value.toStringAsFixed(4)}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 32.h),
            
            // Compass
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Compass background
                    Transform.rotate(
                      angle: (controller.compassHeading.value * (math.pi / 180) * -1),
                      child: Container(
                        width: 300.w,
                        height: 300.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                            width: 2,
                          ),
                        ),
                        child: CustomPaint(
                          painter: CompassPainter(),
                        ),
                      ),
                    ),
                    
                    // Qibla direction indicator
                    Transform.rotate(
                      angle: (controller.qiblaDirection.value - controller.compassHeading.value) * (math.pi / 180),
                      child: Icon(
                        Icons.navigation,
                        size: 80.sp,
                        color: controller.isQiblaAligned
                            ? Colors.green
                            : Theme.of(context).primaryColor,
                      ),
                    ),
                    
                    // Center circle
                    Container(
                      width: 120.w,
                      height: 120.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: controller.isQiblaAligned
                            ? Colors.green.withOpacity(0.2)
                            : Theme.of(context).primaryColor.withOpacity(0.1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.mosque,
                            size: 40.sp,
                            color: controller.isQiblaAligned
                                ? Colors.green
                                : Theme.of(context).primaryColor,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            controller.isQiblaAligned ? 'সঠিক দিক' : 'ঘুরান',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: controller.isQiblaAligned
                                      ? Colors.green
                                      : Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Instructions
            Container(
              margin: EdgeInsets.all(16.w),
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).primaryColor,
                    size: 32.sp,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'আপনার ফোনটি সমতল রাখুন এবং ঘুরান যতক্ষণ না তীরটি সবুজ হয়',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class CompassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw direction markers
    for (int i = 0; i < 360; i += 30) {
      final angle = i * (math.pi / 180);
      final x1 = center.dx + (radius - 20) * math.cos(angle);
      final y1 = center.dy + (radius - 20) * math.sin(angle);
      final x2 = center.dx + radius * math.cos(angle);
      final y2 = center.dy + radius * math.sin(angle);
      
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }

    // Draw N marker
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'N',
        style: TextStyle(
          color: Colors.red,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, 10),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
