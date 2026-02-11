import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/names_controller.dart';

class NamesView extends GetView<NamesController> {
  const NamesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('আল্লাহর ৯৯ নাম'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: controller.names.length,
        itemBuilder: (context, index) {
          final name = controller.names[index];
          return Card(
            margin: EdgeInsets.only(bottom: 12.h),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                name.arabic,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4.h),
                  Text(
                    name.transliteration,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    name.meaning,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
