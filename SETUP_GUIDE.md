# 📱 Islamic App - Complete Setup Guide

## 🎯 Quick Start (For Beginners)

### Step 1: Install Flutter

#### Windows:
1. Download Flutter SDK from: https://docs.flutter.dev/get-started/install/windows
2. Extract the zip file to `C:\src\flutter`
3. Add Flutter to PATH:
   - Search "Environment Variables" in Windows
   - Add `C:\src\flutter\bin` to Path
4. Open Command Prompt and run: `flutter doctor`

#### macOS:
```bash
# Install Flutter
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"
flutter doctor
```

#### Linux:
```bash
# Download and extract Flutter
cd ~
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.x.x-stable.tar.xz
tar xf flutter_linux_3.x.x-stable.tar.xz
export PATH="$PATH:$HOME/flutter/bin"
flutter doctor
```

### Step 2: Install Android Studio

1. Download from: https://developer.android.com/studio
2. Install Android Studio
3. Open Android Studio
4. Go to Tools > SDK Manager
5. Install:
   - Android SDK Platform (API 34)
   - Android SDK Build-Tools
   - Android SDK Command-line Tools

### Step 3: Setup Android Emulator (Optional)

1. In Android Studio: Tools > Device Manager
2. Click "Create Device"
3. Select a phone (e.g., Pixel 7)
4. Download system image (API 34 recommended)
5. Finish setup and start emulator

### Step 4: Setup the Islamic App

1. **Extract the project folder**
   - Extract `islamic_app.zip` to your desired location
   - Example: `C:\Projects\islamic_app` or `~/Projects/islamic_app`

2. **Open Terminal/Command Prompt in the project folder**
   ```bash
   cd path/to/islamic_app
   ```

3. **Get dependencies**
   ```bash
   flutter pub get
   ```

4. **Check everything is working**
   ```bash
   flutter doctor
   ```
   Make sure there are no red X marks.

5. **Run the app**
   
   **With USB Device:**
   - Enable Developer Options on your Android phone
   - Enable USB Debugging
   - Connect phone via USB
   - Run:
   ```bash
   flutter run
   ```

   **With Emulator:**
   - Start Android Emulator from Android Studio
   - Run:
   ```bash
   flutter run
   ```

## 🔧 Detailed Configuration

### Required Tools Checklist
- ✅ Flutter SDK (3.0.0+)
- ✅ Dart SDK (comes with Flutter)
- ✅ Android Studio with Android SDK
- ✅ Android Emulator or Physical Device

### Project Configuration

#### 1. Arabic Font Setup
The app uses Amiri font for Arabic text. You need to add the font files:

1. Create folder: `assets/fonts/`
2. Download Amiri font from: https://fonts.google.com/specimen/Amiri
3. Add these files to `assets/fonts/`:
   - `Amiri-Regular.ttf`
   - `Amiri-Bold.ttf`

#### 2. Additional Assets (Optional)
Create these folders if you want to add custom assets:
- `assets/images/` - for app images
- `assets/icons/` - for custom icons
- `assets/lottie/` - for Lottie animations

### Building the App

#### Debug Build (for testing)
```bash
flutter build apk --debug
```

#### Release Build (for distribution)
```bash
flutter build apk --release
```

The APK will be in: `build/app/outputs/flutter-apk/`

#### App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

## 🐛 Common Issues & Solutions

### Issue 1: "Flutter not found"
**Solution:**
```bash
# Windows
set PATH=%PATH%;C:\src\flutter\bin

# macOS/Linux
export PATH="$PATH:$HOME/flutter/bin"
```

### Issue 2: "Gradle build failed"
**Solution:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Issue 3: "Hive adapter errors"
**Solution:**
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Issue 4: "Permission denied"
**Solution:** 
Grant permissions in Android settings or add to AndroidManifest.xml

### Issue 5: "API not loading data"
**Solution:**
- Check internet connection
- Wait for initial data download (2-3 minutes)
- Check if API is accessible: https://api.alquran.cloud/v1/surah

### Issue 6: "Compass not working"
**Solution:**
- Test on real device (emulator has limited sensor support)
- Calibrate phone compass (wave in figure-8 pattern)
- Grant location permission

## 📋 Testing Checklist

Before distributing the app, test:

- [ ] Home screen loads
- [ ] Quran data downloads on first launch
- [ ] Surah list displays correctly
- [ ] Arabic text displays properly
- [ ] Bangla translation shows
- [ ] Last reading saves and loads
- [ ] Hadith books load
- [ ] Hadith text displays
- [ ] Qibla compass works (real device)
- [ ] Location permission works
- [ ] Prayer times calculate
- [ ] Prayer alarms can be set
- [ ] Notifications work
- [ ] Dark mode toggles
- [ ] Font size adjustment works
- [ ] App works offline after initial load
- [ ] Settings save properly

## 🚀 Optimization Tips

### 1. Reduce APK Size
```bash
flutter build apk --split-per-abi --release
```

### 2. Enable Obfuscation
```bash
flutter build apk --obfuscate --split-debug-info=./debug-info --release
```

### 3. Performance
- Use `const` constructors where possible
- Minimize widget rebuilds
- Use `ListView.builder` for long lists
- Cache network images

## 📱 Distribution

### Google Play Store
1. Create app bundle: `flutter build appbundle --release`
2. Sign in to Google Play Console
3. Create new app
4. Upload the `.aab` file from `build/app/outputs/bundle/release/`
5. Fill in store listing details
6. Submit for review

### Direct APK Distribution
1. Build APK: `flutter build apk --release`
2. Get file from: `build/app/outputs/flutter-apk/app-release.apk`
3. Share via website, email, or file sharing service
4. Users need to enable "Install from Unknown Sources"

## 🎨 Customization Guide

### Change App Name
Edit `android/app/src/main/AndroidManifest.xml`:
```xml
<application
    android:label="Your App Name"
```

### Change App Icon
1. Generate icons at: https://appicon.co/
2. Replace files in:
   - `android/app/src/main/res/mipmap-*/ic_launcher.png`

### Change Package Name
Use this command:
```bash
flutter pub run change_app_package_name:main com.yourcompany.islamic_app
```

### Change Theme Colors
Edit `lib/app/core/theme/app_theme.dart`:
```dart
static const Color primaryColor = Color(0xFF1B5E20); // Change this
```

## 📞 Support & Resources

### Official Documentation
- Flutter: https://docs.flutter.dev/
- GetX: https://pub.dev/packages/get
- Hive: https://docs.hivedb.dev/

### Video Tutorials
- Flutter Setup: https://www.youtube.com/results?search_query=flutter+setup
- Building First App: https://www.youtube.com/results?search_query=flutter+first+app

### Community
- Flutter Discord: https://discord.gg/flutter
- Stack Overflow: Tag `flutter`

## ✅ Final Steps

1. Read through README.md
2. Follow installation steps above
3. Run `flutter doctor` to verify setup
4. Run `flutter pub get` in project directory
5. Connect device or start emulator
6. Run `flutter run`
7. Wait for Quran data to download
8. Test all features
9. Build release APK
10. Distribute or submit to Play Store

## 🎉 You're Done!

Your Islamic app is now ready to use! Share it with the Muslim community and may Allah reward you for this effort. 🤲

---

For any issues not covered here, please check:
1. README.md file
2. Flutter documentation
3. Stack Overflow with tag `flutter`

**JazakAllah Khair! (May Allah reward you with goodness!)** ☪️
