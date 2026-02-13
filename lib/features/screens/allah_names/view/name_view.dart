import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controller/names_controller.dart';
import '../../../../utils/constant/app_strings.dart';
import '../../../../componant/app_container.dart';
import '../../../../componant/app_text.dart';
import '../../../../componant/custom_header.dart';

class NamesView extends StatefulWidget {
  const NamesView({super.key});

  @override
  State<NamesView> createState() => _NamesViewState();
}

class _NamesViewState extends State<NamesView> {
  late final NamesController controller;

  @override
  void initState() {
    super.initState();
    controller = NamesController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Column(
        children: [
          const CustomHeader(
            title: AppString.names99,
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
              itemCount: controller.names.length,
              itemBuilder: (context, index) {
                final name = controller.names[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12.h),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: AppText(
                        '${index + 1}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: AppText(
                      name.arabic,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4.h),
                        AppText(
                          name.transliteration,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: 2.h),
                        AppText(
                          name.meaning,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
