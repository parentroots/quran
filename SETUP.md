# Islamic App - Setup Guide

This guide will help you set up and run the Islamic mobile application on your local machine.

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

### 1. Flutter SDK
- **Version**: 3.0.0 or higher
- **Download**: https://flutter.dev/docs/get-started/install

### 2. Development Tools
- **Android Studio** (recommended) or **VS Code**
- **Android SDK** (API level 21 or higher)
- **Java Development Kit (JDK)** 8 or higher

### 3. Device/Emulator
- Android device with USB debugging enabled, OR
- Android emulator configured in Android Studio

## 🚀 Installation Steps

### Step 1: Verify Flutter Installation

Open a terminal and run:

```bash
flutter doctor
```

This will check your environment and display a report. Resolve any issues before proceeding.

### Step 2: Clone/Download the Project

If you received this as a zip file, extract it. Otherwise:

```bash
git clone <repository-url>
cd islamic_app
```

### Step 3: Install Dependencies

Run the following command in the project root:

```bash
flutter pub get
```

This will download all the required packages from `pubspec.yaml`.

### Step 4: Download Arabic Font

1. Download the Amiri font family from [Google Fonts](https://fonts.google.com/specimen/Amiri)
2. Create the fonts directory:
   ```bash
   mkdir -p assets/fonts
   ```
3. Place the following files in `assets/fonts/`:
   - `Amiri-Regular.ttf`
   - `Amiri-Bold.ttf`

**Note**: The font is already configured in `pubspec.yaml`.

### Step 5: Create Asset Directories

Create the required asset directories:

```bash
mkdir -p assets/images
mkdir -p assets/icons
mkdir -p assets/animations
```

### Step 6: Connect Device or Start Emulator

**For Physical Device:**
1. Enable Developer Options on your Android device
2. Enable USB Debugging
3. Connect device via USB
4. Verify connection: `flutter devices`

**For Emulator:**
1. Open Android Studio
2. Go to AVD Manager
3. Create or start an emulator
4. Verify: `flutter devices`

### Step 7: Run the App

```bash
flutter run
```

The app should build and launch on your device/emulator.

## 🔧 Configuration

### Android Configuration

The Android configuration is already set up in:
- `android/app/build.gradle`
- `android/app/src/main/AndroidManifest.xml`

**Important settings**:
- **minSdkVersion**: 21
- **targetSdkVersion**: 34
- **Permissions**: All necessary permissions are included

### iOS Configuration (Optional)

To run on iOS:

1. Install Xcode from the Mac App Store
2. Install CocoaPods: `sudo gem install cocoapods`
3. Navigate to iOS directory: `cd ios`
4. Install pods: `pod install`
5. Run: `flutter run`

**Note**: Some features may need additional iOS-specific configuration.

## 🎨 Customization

### Change App Name

1. Open `android/app/src/main/AndroidManifest.xml`
2. Change the `android:label` attribute:
   ```xml
   android:label="Your App Name"
   ```

### Change App Icon

1. Prepare your icon (512x512 PNG)
2. Use [App Icon Generator](https://appicon.co/)
3. Replace files in `android/app/src/main/res/mipmap-*`

Or use the `flutter_launcher_icons` package:

1. Add icon configuration in `pubspec.yaml`:
   ```yaml
   flutter_launcher_icons:
     android: true
     image_path: "assets/icon/app_icon.png"
   ```
2. Run: `flutter pub run flutter_launcher_icons`

### Change Package Name

1. Open `android/app/build.gradle`
2. Change `applicationId`:
   ```gradle
   defaultConfig {
       applicationId "com.yourcompany.yourapp"
   }
   ```

3. Update namespace in `android/app/build.gradle`:
   ```gradle
   namespace "com.yourcompany.yourapp"
   ```

### Theme Customization

Edit `lib/core/config/theme.dart` to change colors:

```dart
static const Color primaryGreen = Color(0xFF2E7D32);
static const Color primaryGold = Color(0xFFD4AF37);
// Add your custom colors
```

## 📱 Building for Release

### Build APK

```bash
flutter build apk --release
```

The APK will be located at:
`build/app/outputs/flutter-apk/app-release.apk`

### Build App Bundle (for Play Store)

```bash
flutter build appbundle --release
```

The bundle will be located at:
`build/app/outputs/bundle/release/app-release.aab`

### Build for iOS

```bash
flutter build ios --release
```

## 🐛 Troubleshooting

### Common Issues and Solutions

#### 1. "SDK version not found"

**Solution**:
```bash
flutter doctor --android-licenses
flutter clean
flutter pub get
```

#### 2. "Gradle build failed"

**Solution**:
- Check internet connection
- Update Gradle: `cd android && ./gradlew clean`
- Invalidate caches in Android Studio

#### 3. "Permissions denied on Android"

**Solution**:
- Check `AndroidManifest.xml` has all required permissions
- Request permissions at runtime (already implemented)

#### 4. "Arabic text not displaying"

**Solution**:
- Ensure Amiri font files are in `assets/fonts/`
- Run `flutter clean` and `flutter pub get`
- Rebuild the app

#### 5. "API calls failing"

**Solution**:
- Check internet connection
- Verify API endpoints are accessible
- Check Android emulator network settings

#### 6. "Qibla not working"

**Solution**:
- Grant location permission
- Enable GPS on device
- Test on physical device (emulator may not support compass)

#### 7. "Notifications not working"

**Solution**:
- Grant notification permission
- Check device notification settings
- Enable exact alarm permission (Android 12+)

### Getting Help

If you encounter issues:

1. Check the error message carefully
2. Search for the error on Stack Overflow
3. Run `flutter doctor -v` for detailed diagnostics
4. Check Flutter documentation: https://flutter.dev/docs

## 📊 Performance Tips

### 1. Enable Performance Overlay

```bash
flutter run --profile
```

### 2. Analyze App Size

```bash
flutter build apk --analyze-size
```

### 3. Memory Profiling

Use DevTools:
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

## 🧪 Testing

### Run All Tests

```bash
flutter test
```

### Run Specific Test

```bash
flutter test test/quran_controller_test.dart
```

### Integration Tests

```bash
flutter drive --target=test_driver/app.dart
```

## 📦 Dependencies

### Core Dependencies
- `get: ^4.6.6` - State management
- `hive: ^2.2.3` - Local database
- `http: ^1.1.0` - API calls

### Feature Dependencies
- `flutter_qiblah: ^2.2.0` - Qibla direction
- `geolocator: ^10.1.0` - Location services
- `flutter_local_notifications: ^16.3.0` - Alarms

### UI Dependencies
- `google_fonts: ^6.1.0` - Typography
- `shimmer: ^3.0.0` - Loading effects

## 🔒 Security

### API Keys

If you add API keys:

1. Never commit them to version control
2. Use environment variables
3. Add to `.gitignore`:
   ```
   .env
   *.key
   ```

### Signing Config (Production)

For production builds:

1. Generate keystore:
   ```bash
   keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
   ```

2. Create `android/key.properties`:
   ```properties
   storePassword=<password>
   keyPassword=<password>
   keyAlias=key
   storeFile=<path-to-key.jks>
   ```

3. Update `android/app/build.gradle` signing config

## 📝 Development Workflow

### Recommended Workflow

1. **Create feature branch**
   ```bash
   git checkout -b feature/new-feature
   ```

2. **Make changes**
   - Write code
   - Test thoroughly
   - Follow code style

3. **Test**
   ```bash
   flutter test
   flutter analyze
   ```

4. **Commit**
   ```bash
   git add .
   git commit -m "Add new feature"
   ```

5. **Merge**
   ```bash
   git checkout main
   git merge feature/new-feature
   ```

### Code Quality

Run before committing:

```bash
# Format code
flutter format .

# Analyze code
flutter analyze

# Run tests
flutter test
```

## 📱 Device Testing

### Recommended Test Devices

- **Low-end**: Android 5.0 (API 21), 1GB RAM
- **Mid-range**: Android 10 (API 29), 4GB RAM
- **High-end**: Android 14 (API 34), 8GB RAM

### Test Checklist

- [ ] All features work on different Android versions
- [ ] UI displays correctly on different screen sizes
- [ ] Offline mode works
- [ ] Notifications trigger correctly
- [ ] Permissions are handled properly
- [ ] Dark mode works
- [ ] App doesn't crash
- [ ] Performance is smooth

## 🌐 Network Requirements

### Development
- Internet connection for API calls
- No special network configuration needed

### Production
- All APIs use HTTPS
- No proxy configuration needed
- Works on mobile data and WiFi

## 📚 Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [GetX Documentation](https://pub.dev/packages/get)
- [Hive Documentation](https://docs.hivedb.dev/)
- [Material Design Guidelines](https://material.io/design)

## ✅ Verification

After setup, verify everything works:

1. ✅ App launches successfully
2. ✅ Quran page loads and displays Arabic text
3. ✅ Hadith books are visible
4. ✅ Qibla compass works (on device)
5. ✅ Prayer times display
6. ✅ Settings page accessible
7. ✅ Dark mode toggles correctly
8. ✅ Offline mode works (disable internet and test)

## 🎉 You're Ready!

If all steps are completed successfully, you're ready to use and develop the Islamic app!

For questions or issues, please refer to the troubleshooting section or check the README.md file.

---

**Happy Coding! 🚀**
