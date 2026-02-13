import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:islamic_app/componant/app_container.dart';
import 'package:islamic_app/componant/app_text.dart';

import '../../../../componant/custom_header.dart';
import '../controller/calendar_controller.dart';
import '../../../../utils/constant/app_strings.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late final CalendarController controller;

  @override
  void initState() {
    super.initState();
    controller = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(AppString.calendarTitle),
      ),
      body: Obx(() {
        final gregDate = controller.selectedGregorianDate.value;
        final hijriDate = controller.selectedHijriDate.value;

        return Column(
          children: [
            CustomHeader(
              title:
                  '${hijriDate.hDay} ${controller.getBengaliHijriMonth()}, ${hijriDate.hYear} হিজরি',
              subtitle: AppText(
                DateFormat('EEEE, d MMMM yyyy').format(gregDate),
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white70,
                ),
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
            AppContainer(
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
                    child: AppText(
                      AppString.hijriDateNotice,
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
