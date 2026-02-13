import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/features/screens/home/controller/home_controller.dart';

import '../../../../componant/app_container.dart';
import '../../../../componant/app_text.dart';

Widget buildFeatureCard(
  BuildContext context, {
  IconData? icon,
  String? imagePath,
  required String title,
  required Color color,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: AppContainer(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppContainer(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
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
          AppText(
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
