import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/hadith_controller.dart';
import '../../../../core/routes/app_pages.dart';
import '../../../../core/config/theme.dart';

class HadithPage extends GetView<HadithController> {
  const HadithPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الحديث'),
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.hadithBooks.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.hadithBooks.length,
          itemBuilder: (context, index) {
            final book = controller.hadithBooks[index];
            return _buildHadithBookCard(context, book);
          },
        );
      }),
    );
  }
  
  Widget _buildHadithBookCard(BuildContext context, Map<String, dynamic> book) {
    return Card(
      child: InkWell(
        onTap: () {
          Get.toNamed(
            Routes.HADITH_DETAIL,
            arguments: book,
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Book Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryGreen.withOpacity(0.2),
                      AppTheme.secondaryTeal.withOpacity(0.2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.menu_book,
                  color: AppTheme.primaryGreen,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              
              // Book Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book['name'],
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${book['totalHadith']} Hadiths',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Arabic Name
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    book['nameArabic'],
                    style: const TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
