import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../controllers/calendar_controller.dart';

class CalendarView extends GetView<CalendarController> {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('হিজরি ক্যালেন্ডার'),
      ),
      body: Obx(() {
        final gregDate = controller.selectedGregorianDate.value;
        final hijriDate = controller.selectedHijriDate.value;

        return Column(
          children: [
            // Month Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    '${hijriDate.hDay} ${controller.getBengaliHijriMonth()}, ${hijriDate.hYear} হিজরি',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    DateFormat('EEEE, d MMMM yyyy').format(gregDate),
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40.h),

            // Date Picker (Interactive)
            CalendarDatePicker(
              initialDate: gregDate,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
              onDateChanged: (date) => controller.updateDate(date),
            ),

            const Spacer(),

            // Important Dates Info Card
            Container(
              margin: EdgeInsets.all(20.w),
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline,
                      color: Theme.of(context).primaryColor),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'চাঁদ দেখার উপর ভিত্তি করে হিজরি তারিখ একদিন এদিক-ওদিক হতে পারে।',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
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
