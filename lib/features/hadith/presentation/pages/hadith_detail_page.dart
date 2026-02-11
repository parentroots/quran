import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/hadith_controller.dart';
import '../../../../core/config/theme.dart';

class HadithDetailPage extends StatefulWidget {
  const HadithDetailPage({super.key});

  @override
  State<HadithDetailPage> createState() => _HadithDetailPageState();
}

class _HadithDetailPageState extends State<HadithDetailPage> {
  final HadithController controller = Get.find<HadithController>();
  final Map<String, dynamic> book = Get.arguments as Map<String, dynamic>;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadHadiths();
  }

  Future<void> loadHadiths() async {
    await controller.loadHadithsFromBook(book['id']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book['name']),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              setState(() => isLoading = true);
              final newHadith = await controller.getRandomHadith(book['id']);
              if (newHadith != null) {
                controller.hadiths.insert(0, newHadith);
              }
              setState(() => isLoading = false);
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoadingHadith.value && controller.hadiths.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        if (controller.hadiths.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.book_outlined, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text('No Hadiths loaded yet'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: loadHadiths,
                  child: const Text('Load Hadiths'),
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.hadiths.length,
          itemBuilder: (context, index) {
            final hadith = controller.hadiths[index];
            return _buildHadithCard(hadith, index);
          },
        );
      }),
    );
  }

  Widget _buildHadithCard(Map<String, dynamic> hadith, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hadith Number and Actions
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Hadith ${hadith['hadithNumber'] ?? index + 1}',
                    style: const TextStyle(
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.share, size: 20),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 20),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Narrator
            if (hadith['englishNarrator'] != null &&
                hadith['englishNarrator'].toString().isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 16,
                      color: AppTheme.primaryGold,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        hadith['englishNarrator'],
                        style: const TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          color: AppTheme.primaryGold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            
            // Arabic Text
            if (hadith['hadithArabic'] != null &&
                hadith['hadithArabic'].toString().isNotEmpty)
              Column(
                children: [
                  Text(
                    hadith['hadithArabic'],
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 24,
                      height: 2.0,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),
                ],
              ),
            
            // English Translation
            if (hadith['hadithEnglish'] != null &&
                hadith['hadithEnglish'].toString().isNotEmpty)
              Text(
                hadith['hadithEnglish'],
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.8,
                ),
              ),
            
            // Book and Chapter Info
            if (hadith['book'] != null || hadith['chapter'] != null)
              Column(
                children: [
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (hadith['book'] != null &&
                          hadith['book']['bookName'] != null)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Book',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                hadith['book']['bookName'],
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (hadith['chapter'] != null &&
                          hadith['chapter']['chapterEnglish'] != null)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Chapter',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                hadith['chapter']['chapterEnglish'],
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
