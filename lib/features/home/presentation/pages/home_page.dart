import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_pages.dart';
import '../../../../core/config/theme.dart';
import '../../../../core/services/storage_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final storageService = Get.find<StorageService>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Islamic App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Get.toNamed(Routes.SETTINGS),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Welcome Section
            _buildWelcomeSection(context),
            
            const SizedBox(height: 24),
            
            // Quick Actions Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  _buildFeatureCard(
                    context,
                    title: 'Al-Quran',
                    subtitle: 'Read the Holy Quran',
                    icon: Icons.book,
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryGreen, AppTheme.secondaryTeal],
                    ),
                    onTap: () => Get.toNamed(Routes.QURAN),
                  ),
                  _buildFeatureCard(
                    context,
                    title: 'Hadith',
                    subtitle: 'Prophetic Traditions',
                    icon: Icons.menu_book,
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryGold,
                        AppTheme.primaryGold.withOpacity(0.7),
                      ],
                    ),
                    onTap: () => Get.toNamed(Routes.HADITH),
                  ),
                  _buildFeatureCard(
                    context,
                    title: 'Qibla',
                    subtitle: 'Find Prayer Direction',
                    icon: Icons.explore,
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.secondaryTeal,
                        AppTheme.secondaryTeal.withOpacity(0.7),
                      ],
                    ),
                    onTap: () => Get.toNamed(Routes.QIBLA),
                  ),
                  _buildFeatureCard(
                    context,
                    title: 'Prayer Times',
                    subtitle: 'Daily Prayer Schedule',
                    icon: Icons.access_time,
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.accentAmber,
                        AppTheme.accentAmber.withOpacity(0.7),
                      ],
                    ),
                    onTap: () => Get.toNamed(Routes.PRAYER_TIMES),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Continue Reading Section
            if (storageService.lastReadSurah > 1)
              _buildContinueReadingSection(context, storageService),
            
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
  
  Widget _buildWelcomeSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryGreen, AppTheme.secondaryTeal],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Assalamu Alaikum',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'May peace be upon you',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'All data is cached for offline access',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildContinueReadingSection(
    BuildContext context,
    StorageService storage,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryGold.withOpacity(0.2),
            AppTheme.accentAmber.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryGold.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.toNamed(Routes.QURAN),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGold,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.bookmark,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Continue Reading',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Surah ${storage.lastReadSurah}, Ayah ${storage.lastReadAyah}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppTheme.primaryGold,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
