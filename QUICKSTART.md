# 🚀 Quick Start Guide

Get the Islamic app running in 5 minutes!

## ⚡ Quick Setup (TL;DR)

```bash
# 1. Navigate to project
cd islamic_app

# 2. Install dependencies
flutter pub get

# 3. Connect device or start emulator
# Check: flutter devices

# 4. Run the app
flutter run
```

## 📋 Essential Requirements

✅ Flutter SDK 3.0+
✅ Android Studio or VS Code
✅ Android device/emulator
✅ Internet connection (first run only)

## 🎯 What You Get

### Core Features
- ✅ **Quran Reader** - 114 Surahs with Arabic, Bangla & English
- ✅ **Hadith Collections** - 6 authentic books
- ✅ **Qibla Finder** - Compass-based direction
- ✅ **Prayer Times** - 5 daily prayers with alarms
- ✅ **Offline Mode** - Works without internet after first load
- ✅ **Dark Mode** - Easy on the eyes

## 📂 Project Structure (Simplified)

```
islamic_app/
├── lib/
│   ├── main.dart                    # Start here
│   ├── core/                        # Theme, routes, services
│   └── features/                    # Quran, Hadith, Qibla, etc.
├── pubspec.yaml                     # Dependencies
├── README.md                        # Full documentation
└── SETUP.md                         # Detailed setup guide
```

## 🎨 Key Files to Know

### 1. Main Entry Point
`lib/main.dart` - App initialization

### 2. Theme Configuration
`lib/core/config/theme.dart` - Colors and styles

### 3. Routes
`lib/core/routes/app_pages.dart` - Navigation

### 4. Features
- `lib/features/quran/` - Quran module
- `lib/features/hadith/` - Hadith module
- `lib/features/qibla/` - Qibla module
- `lib/features/prayer_times/` - Prayer times module

## ⚙️ Important Dependencies

```yaml
get: ^4.6.6                          # State management
hive: ^2.2.3                         # Local storage
http: ^1.1.0                         # API calls
flutter_qiblah: ^2.2.0              # Qibla finder
geolocator: ^10.1.0                 # Location
flutter_local_notifications: ^16.3.0 # Alarms
google_fonts: ^6.1.0                # Typography
```

## 🔧 First Time Setup

### Step 1: Download Arabic Font
1. Download Amiri font from [Google Fonts](https://fonts.google.com/specimen/Amiri)
2. Create folder: `assets/fonts/`
3. Add files:
   - `Amiri-Regular.ttf`
   - `Amiri-Bold.ttf`

### Step 2: Create Asset Folders
```bash
mkdir -p assets/images
mkdir -p assets/icons
mkdir -p assets/animations
```

### Step 3: Check Configuration
```bash
flutter doctor
```
Fix any issues shown.

## 📱 Running the App

### On Android Device
```bash
# Enable USB debugging on device
# Connect via USB
flutter devices  # Verify connection
flutter run
```

### On Emulator
```bash
# Start emulator from Android Studio
flutter devices  # Should show emulator
flutter run
```

## 🎨 Customization Quick Tips

### Change App Colors
Edit `lib/core/config/theme.dart`:
```dart
static const Color primaryGreen = Color(0xFF2E7D32);  // Your color
static const Color primaryGold = Color(0xFFD4AF37);   // Your color
```

### Change App Name
Edit `android/app/src/main/AndroidManifest.xml`:
```xml
android:label="Your App Name"
```

## 🏗️ Build for Release

### APK (for direct install)
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### App Bundle (for Play Store)
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

## 🐛 Common Issues

### "SDK not found"
```bash
flutter doctor --android-licenses
```

### "Gradle build failed"
```bash
cd android && ./gradlew clean
cd .. && flutter clean && flutter pub get
```

### "Arabic text not showing"
- Make sure Amiri fonts are in `assets/fonts/`
- Run `flutter clean && flutter pub get`

### "Location permission denied"
- Grant location permission in app
- Enable GPS on device

## 📚 Documentation

- **README.md** - Full project overview
- **SETUP.md** - Detailed setup instructions
- **PROJECT_STRUCTURE.md** - Architecture details
- **API_DOCUMENTATION.md** - API integration guide

## 🎯 Testing Checklist

After running the app, verify:

- [ ] App launches successfully
- [ ] Quran page shows Arabic text
- [ ] Hadith books are listed
- [ ] Qibla compass works (on device)
- [ ] Prayer times display
- [ ] Settings accessible
- [ ] Dark mode works
- [ ] Turn off internet - app still works

## 💡 Pro Tips

1. **First Load**: Requires internet to fetch data
2. **Offline Mode**: After first load, works completely offline
3. **Caching**: Data is cached automatically
4. **Dark Mode**: Toggle in Settings
5. **Bookmarks**: Last read position is saved automatically
6. **Alarms**: Can be toggled for each prayer individually

## 🎨 Color Scheme

- **Primary Green**: #2E7D32
- **Gold**: #D4AF37
- **Teal**: #00695C
- **Amber**: #FFA000

## 📦 Package Sizes

- **Debug APK**: ~50 MB
- **Release APK**: ~25 MB
- **App Bundle**: ~20 MB

## 🔄 Update Dependencies

```bash
flutter pub upgrade
flutter pub get
```

## 🧹 Clean Build

If something breaks:
```bash
flutter clean
rm -rf android/app/build
flutter pub get
flutter run
```

## 🎯 Next Steps

1. ✅ Run the app
2. 📖 Read README.md for full features
3. 🎨 Customize theme and colors
4. 📱 Test on different devices
5. 🏗️ Build release version

## 🤝 Need Help?

- Check **SETUP.md** for detailed instructions
- Review **PROJECT_STRUCTURE.md** for architecture
- See **API_DOCUMENTATION.md** for API details
- Search error messages on Stack Overflow

## ✨ Features at a Glance

| Feature | Status | Offline |
|---------|--------|---------|
| Quran Reader | ✅ | ✅ |
| Hadith Collections | ✅ | ✅ |
| Qibla Finder | ✅ | ✅* |
| Prayer Times | ✅ | ✅ |
| Dark Mode | ✅ | ✅ |
| Notifications | ✅ | ✅ |

*Requires location permission

## 🎊 You're Ready!

That's it! The app should now be running on your device. Explore the features and enjoy!

For detailed information, check out the other documentation files.

---

**Happy Coding! 🚀 May Allah bless your efforts!**
