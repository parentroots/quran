import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/dependency_injection/dependency_injection.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'features/theme/app_theme.dart';
import 'routes/app_rout.dart';
import 'services/notification_service.dart';
import 'core/storage/local_storage.dart';
import 'services/location_service.dart';
import 'services/tts_service.dart';
import 'services/prayer_service.dart';
import 'services/zakat_service.dart';
import 'core/network/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Initialize timezone
  tz.initializeTimeZones();

  // Initialize services
  await initServices();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

Future<void> initServices() async {
  // Initialize generic ApiService
  await ApiService.init();

  // Initialize Services
  await Get.putAsync(() => LocalStorage().init());
  await Get.putAsync(() => NotificationService().init());
  await Get.putAsync(() => LocationService().init());
  await Get.putAsync(() => TtsService().init());
  await Get.putAsync(() => PrayerService().init());
  await Get.putAsync(() => ZakatService().init());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Islamic App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          initialBinding: DependencyInjection(),
          initialRoute: AppRoutes.initial,
          getPages: AppRoutes.routes,
          defaultTransition: Transition.cupertino,
        );
      },
    );
  }
}
