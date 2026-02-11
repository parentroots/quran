# ⚡ QUICK START CHECKLIST

Follow these steps in order:

## ☑️ Pre-Installation (One-time setup)

- [ ] Install Flutter SDK
  - Download: https://docs.flutter.dev/get-started/install
  - Add to PATH
  - Run: `flutter doctor`

- [ ] Install Android Studio
  - Download: https://developer.android.com/studio
  - Install Android SDK (API 21+)
  - Setup emulator OR connect physical device

## ☑️ Project Setup

- [ ] Extract `islamic_app` folder
- [ ] Open terminal/command prompt in the folder
- [ ] Run: `flutter pub get`
- [ ] Download Amiri fonts:
  - Visit: https://fonts.google.com/specimen/Amiri
  - Download Regular and Bold .ttf files
  - Create folder: `assets/fonts/`
  - Place files:
    - `assets/fonts/Amiri-Regular.ttf`
    - `assets/fonts/Amiri-Bold.ttf`

## ☑️ First Run

- [ ] Connect Android device OR start emulator
- [ ] Run: `flutter run`
- [ ] Wait 2-3 minutes for Quran data download
- [ ] Grant location permission (for Qibla)
- [ ] Grant notification permission (for alarms)

## ☑️ Testing

- [ ] Home screen loads ✅
- [ ] Quran module works ✅
- [ ] Hadith module works ✅
- [ ] Qibla compass works (test on real device) ✅
- [ ] Prayer times show ✅
- [ ] Alarms can be set ✅
- [ ] Dark mode toggles ✅
- [ ] Offline mode works ✅

## ☑️ Building APK

- [ ] For testing: `flutter build apk --debug`
- [ ] For release: `flutter build apk --release`
- [ ] Find APK in: `build/app/outputs/flutter-apk/`

## 🚨 Common Issues

### "Flutter not found"
```bash
# Add Flutter to PATH
# Windows: set PATH=%PATH%;C:\flutter\bin
# Mac/Linux: export PATH="$PATH:$HOME/flutter/bin"
```

### "Gradle build failed"
```bash
flutter clean
flutter pub get
flutter run
```

### "API not loading"
- Check internet connection
- Wait 2-3 minutes for download
- API: https://api.alquran.cloud/v1

### "Compass not working"
- Must test on real device (not emulator)
- Grant location permission
- Calibrate compass (wave phone in figure-8)

## 📚 Documentation

| File | Purpose |
|------|---------|
| README.md | Main documentation |
| SETUP_GUIDE.md | Detailed step-by-step guide |
| PROJECT_OVERVIEW.md | Complete feature list |

## ⏱️ Time Estimate

- Setup (first time): 30-60 minutes
- App first run: 3-5 minutes
- Testing: 10-15 minutes
- Building APK: 5-10 minutes

## ✅ Success Criteria

You know everything is working when:
1. App launches without errors
2. Quran data downloads and displays
3. All modules are accessible
4. Offline mode works
5. APK builds successfully

## 🎉 Next Steps

After successful setup:
1. Customize app name (AndroidManifest.xml)
2. Change colors (app_theme.dart)
3. Add your own branding
4. Test thoroughly
5. Build release APK
6. Distribute or submit to Play Store

## 🆘 Still Need Help?

1. Read SETUP_GUIDE.md (detailed instructions)
2. Check Flutter docs: https://docs.flutter.dev
3. Run: `flutter doctor -v` (verbose diagnostics)
4. Search error messages on Stack Overflow

---

**You've got this! May Allah make it easy for you! 🤲**
