# Islamic App - Complete Flutter Application

A beautiful and feature-rich Islamic mobile application built with Flutter, featuring Al-Quran, Hadith, Qibla direction, Prayer times, and more.

## 🌟 Features

### 1. **Al-Quran Module**
- Complete Quran with 114 Surahs
- Arabic text with Bangla translation
- Offline reading (cached data)
- Last reading bookmark
- Beautiful Arabic typography (Amiri font)
- Smooth scrolling and readable UI

### 2. **Hadith Module**
- Multiple Hadith collections (Bukhari, Muslim, Abu Dawud, etc.)
- Bangla Hadith text
- Offline access after first load
- Category-wise browsing

### 3. **Qibla Direction**
- Real-time compass-based Qibla finder
- Accurate direction using device sensors
- Visual indicator for correct alignment
- Location-based calculation

### 4. **Prayer Times & Alarms**
- Automatic prayer time calculation
- Customizable prayer alarms
- Local notifications
- Works even when app is closed

### 5. **Additional Features**
- Dark mode support
- Customizable font sizes
- Clean architecture
- Offline-first approach
- Beautiful Material 3 UI

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (2.17.0 or higher)
- Android Studio or VS Code with Flutter extensions
- Android device or emulator (API 21+)

### Installation Steps

1. **Clone or extract the project:**
```bash
cd islamic_app
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Generate Hive adapters (if needed):**
```bash
flutter packages pub run build_runner build
```

4. **Run the app:**
```bash
flutter run
```

## 📱 Configuration

### Android Configuration

The app requires the following permissions which are already added in the `AndroidManifest.xml`:

- Internet permission (for API calls)
- Location permission (for Qibla and Prayer times)
- Notification permission (for Prayer alarms)
- Wake lock permission (for alarms)

### API Configuration

The app uses the following public APIs:

- **Quran API:** https://api.alquran.cloud/v1
- **Prayer Times:** Calculated locally based on user location

No API keys are required as we're using public endpoints.

## 🏗️ Project Structure

```
lib/
├── main.dart                          # App entry point
├── app/
│   ├── core/
│   │   └── theme/
│   │       └── app_theme.dart        # Theme configuration
│   ├── data/
│   │   └── models/                   # Data models
│   │       ├── quran_model.dart
│   │       ├── hadith_model.dart
│   │       └── prayer_model.dart
│   ├── modules/                      # Feature modules
│   │   ├── home/
│   │   ├── quran/
│   │   ├── hadith/
│   │   ├── qibla/
│   │   ├── prayer/
│   │   └── settings/
│   ├── routes/                       # App navigation
│   │   ├── app_pages.dart
│   │   └── app_routes.dart
│   └── services/                     # Core services
│       ├── api_service.dart
│       ├── storage_service.dart
│       └── notification_service.dart
```

## 🎨 Tech Stack

- **Framework:** Flutter 3.x
- **State Management:** GetX
- **Local Storage:** Hive + SharedPreferences
- **Networking:** Dio
- **UI Components:** Material 3
- **Fonts:** Google Fonts, Amiri (Arabic)
- **Sensors:** Flutter Compass, Geolocator
- **Notifications:** Flutter Local Notifications

## 📦 Key Dependencies

```yaml
dependencies:
  get: ^4.6.6                           # State management
  hive: ^2.2.3                          # Local database
  hive_flutter: ^1.1.0
  dio: ^5.4.0                           # HTTP client
  flutter_compass: ^0.7.0               # Compass sensor
  geolocator: ^10.1.0                   # Location
  flutter_local_notifications: ^16.3.0  # Notifications
  google_fonts: ^6.1.0                  # Typography
  flutter_screenutil: ^5.9.0            # Responsive UI
```

## 🔑 Important Notes

### First Launch
- On first launch, the app will download Quran data from the API
- This may take 2-3 minutes depending on your internet connection
- After download, all data is cached locally for offline use
- You'll see a progress indicator during download

### Permissions
- **Location:** Required for Qibla direction and Prayer times
- **Notifications:** Required for Prayer alarms
- Grant these permissions when prompted

### Offline Mode
- After initial data download, the app works fully offline
- Qibla and Prayer times require location (uses cached location if available)
- All Quran and Hadith data is available offline

## 🐛 Troubleshooting

### Issue: App not building
```bash
flutter clean
flutter pub get
flutter run
```

### Issue: Hive errors
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Issue: Permission errors
- Check AndroidManifest.xml has all required permissions
- On Android 12+, ensure notification permission is granted

### Issue: Location not working
- Enable location services on your device
- Grant location permission to the app
- Ensure GPS is enabled

## 📱 Building APK

To build a release APK:

```bash
flutter build apk --release
```

The APK will be located at: `build/app/outputs/flutter-apk/app-release.apk`

To build an app bundle (for Play Store):

```bash
flutter build appbundle --release
```

## 🎯 Future Enhancements

- [ ] Tafsir (Quran commentary)
- [ ] Audio recitation
- [ ] Quran search functionality
- [ ] Prayer tracking/statistics
- [ ] Islamic calendar
- [ ] Dhikr counter
- [ ] Multiple language support
- [ ] Widget support

## 📄 License

This project is created for educational purposes. Please ensure you have rights to use any APIs or content.

## 🤝 Contributing

This is a demonstration project. Feel free to use it as a template for your own Islamic app!

## 🙏 Credits

- Quran data from: AlQuran Cloud API
- Hadith data: Mock data (in production, use a real Hadith API)
- Icons: Material Design Icons
- Fonts: Google Fonts, Amiri Font

## 📞 Support

For issues or questions:
1. Check the Troubleshooting section
2. Ensure all dependencies are installed
3. Verify Flutter and Dart versions

---

**Built with ❤️ for the Muslim community**

## Bangla Instructions (বাংলা নির্দেশনা)

### ইনস্টলেশন
1. Flutter SDK ইনস্টল করুন
2. প্রজেক্ট ফোল্ডারে যান
3. `flutter pub get` চালান
4. `flutter run` দিয়ে অ্যাপ চালান

### প্রথম ব্যবহার
- প্রথমবার অ্যাপ খোলার সময় কুরআন ডাটা ডাউনলোড হবে
- ইন্টারনেট সংযোগ প্রয়োজন
- ডাউনলোডের পর সম্পূর্ণ অফলাইনে ব্যবহার করা যাবে

### অনুমতি
- অবস্থান অনুমতি (কিবলা ও নামাজের সময়ের জন্য)
- নোটিফিকেশন অনুমতি (নামাজের অ্যালার্মের জন্য)

আল্লাহ আপনাদের সাথে থাকুন! 🤲
