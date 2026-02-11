# Islamic App - Project Structure

## 📁 Complete File Structure

```
islamic_app/
│
├── android/                          # Android native code
│   ├── app/
│   │   ├── src/
│   │   │   └── main/
│   │   │       └── AndroidManifest.xml
│   │   └── build.gradle
│   └── build.gradle
│
├── assets/                           # App assets
│   ├── fonts/
│   │   ├── Amiri-Regular.ttf
│   │   └── Amiri-Bold.ttf
│   ├── images/
│   ├── icons/
│   └── animations/
│
├── lib/
│   ├── main.dart                    # App entry point
│   │
│   ├── core/                        # Core utilities
│   │   ├── config/
│   │   │   └── theme.dart           # App theme (light & dark)
│   │   │
│   │   ├── routes/
│   │   │   ├── app_pages.dart       # Route definitions
│   │   │   └── app_routes.dart      # Route constants
│   │   │
│   │   ├── bindings/
│   │   │   └── initial_binding.dart # Initial dependencies
│   │   │
│   │   └── services/
│   │       ├── storage_service.dart       # Hive & SharedPreferences
│   │       └── notification_service.dart  # Local notifications
│   │
│   └── features/                    # Feature modules
│       │
│       ├── home/
│       │   └── presentation/
│       │       └── pages/
│       │           └── home_page.dart
│       │
│       ├── quran/
│       │   ├── data/
│       │   │   ├── models/
│       │   │   │   ├── surah_model.dart
│       │   │   │   └── ayah_model.dart
│       │   │   └── services/
│       │   │       └── quran_api_service.dart
│       │   │
│       │   └── presentation/
│       │       ├── controllers/
│       │       │   └── quran_controller.dart
│       │       ├── bindings/
│       │       │   └── quran_binding.dart
│       │       └── pages/
│       │           ├── quran_page.dart
│       │           └── surah_detail_page.dart
│       │
│       ├── hadith/
│       │   ├── data/
│       │   │   └── services/
│       │   │       └── hadith_api_service.dart
│       │   │
│       │   └── presentation/
│       │       ├── controllers/
│       │       │   └── hadith_controller.dart
│       │       ├── bindings/
│       │       │   └── hadith_binding.dart
│       │       └── pages/
│       │           ├── hadith_page.dart
│       │           └── hadith_detail_page.dart
│       │
│       ├── qibla/
│       │   └── presentation/
│       │       ├── controllers/
│       │       │   └── qibla_controller.dart
│       │       ├── bindings/
│       │       │   └── qibla_binding.dart
│       │       └── pages/
│       │           └── qibla_page.dart
│       │
│       ├── prayer_times/
│       │   └── presentation/
│       │       ├── controllers/
│       │       │   └── prayer_times_controller.dart
│       │       ├── bindings/
│       │       │   └── prayer_times_binding.dart
│       │       └── pages/
│       │           └── prayer_times_page.dart
│       │
│       └── settings/
│           └── presentation/
│               └── pages/
│                   └── settings_page.dart
│
├── pubspec.yaml                     # Dependencies
└── README.md                        # Documentation
```

## 🎯 Module Breakdown

### 1. Core Module
**Purpose**: Shared utilities and configurations

**Files**:
- `theme.dart` - Light and dark theme definitions
- `app_pages.dart` - GetX route definitions
- `app_routes.dart` - Route name constants
- `initial_binding.dart` - App-wide dependencies
- `storage_service.dart` - Local data management
- `notification_service.dart` - Prayer alarms

### 2. Quran Module
**Purpose**: Complete Quran reading with translations

**Components**:
- **Models**: `SurahModel`, `AyahModel`
- **Service**: `QuranApiService` - API integration
- **Controller**: `QuranController` - Business logic
- **Pages**: 
  - `quran_page.dart` - Surah list
  - `surah_detail_page.dart` - Ayah reading

**Features**:
- 114 Surahs list
- Arabic text with Bangla & English translation
- Offline caching
- Last read bookmark
- Beautiful typography

### 3. Hadith Module
**Purpose**: Authentic Hadith collections

**Components**:
- **Service**: `HadithApiService` - API integration
- **Controller**: `HadithController` - Business logic
- **Pages**:
  - `hadith_page.dart` - Book selection
  - `hadith_detail_page.dart` - Hadith reading

**Features**:
- 6 major Hadith books
- Arabic text with translation
- Offline support
- Random hadith generator

### 4. Qibla Module
**Purpose**: Prayer direction finder

**Components**:
- **Controller**: `QiblaController` - Compass logic
- **Page**: `qibla_page.dart` - Compass UI

**Features**:
- Real-time compass
- Animated direction indicator
- Location-based accuracy
- Permission handling

### 5. Prayer Times Module
**Purpose**: Daily prayer schedule with alarms

**Components**:
- **Controller**: `PrayerTimesController` - Time calculations
- **Page**: `prayer_times_page.dart` - Schedule display

**Features**:
- 5 daily prayers
- Individual alarms
- Next prayer countdown
- Location-based times

### 6. Settings Module
**Purpose**: App configuration

**Features**:
- Dark mode toggle
- Cache management
- About information
- Data source credits

## 🔄 Data Flow

### Quran Data Flow
```
User → QuranPage → QuranController
                        ↓
                   Check Cache?
                   ↙          ↘
              Yes (Hive)    No (API)
                   ↓          ↓
              Load Local  → Fetch → Cache → Display
```

### Hadith Data Flow
```
User → HadithPage → Select Book → HadithController
                                        ↓
                                   Check Cache?
                                   ↙          ↘
                              Yes (Hive)    No (API)
                                   ↓          ↓
                              Load Local  → Fetch → Cache → Display
```

### Prayer Times Flow
```
User → PrayerTimesPage → PrayerTimesController
                               ↓
                          Get Location
                               ↓
                       Calculate Times
                               ↓
                    Schedule Notifications
                               ↓
                         Display UI
```

## 🎨 UI Components

### Common Widgets
- Cards with rounded corners (16px)
- Gradient containers
- Islamic color palette (Green, Gold, Teal)
- Material 3 components
- Smooth animations

### Typography
- **Headings**: Poppins font
- **Body**: Poppins font
- **Arabic**: Amiri font
- Responsive text sizes

### Color Scheme
```dart
Primary Green: #2E7D32
Primary Gold: #D4AF37
Secondary Teal: #00695C
Accent Amber: #FFA000
```

## 📦 State Management

Using **GetX** for:
1. **State Management**: Reactive programming with Rx
2. **Dependency Injection**: Controllers and services
3. **Navigation**: Named routes
4. **Bindings**: Automatic dependency injection

### Controller Pattern
```dart
class QuranController extends GetxController {
  // Observables
  final RxList<SurahModel> surahs = <SurahModel>[].obs;
  final RxBool isLoading = false.obs;
  
  // Methods
  Future<void> loadSurahs() async { ... }
  
  // Lifecycle
  @override
  void onInit() { ... }
}
```

## 💾 Storage Strategy

### Hive Boxes
1. `settings` - User preferences
2. `quran_cache` - Quran data
3. `hadith_cache` - Hadith data

### SharedPreferences
- Dark mode state
- Last read position
- Prayer alarm settings

### Cache Keys
```dart
// Quran
'surahs_list' - All surahs
'surah_{number}' - Individual surah data

// Hadith
'hadith_{bookId}' - Hadith collection

// Settings
'isDarkMode' - Theme preference
'lastReadSurah' - Bookmark
'lastReadAyah' - Bookmark
'alarm_{prayer}' - Alarm settings
```

## 🔐 Permissions

### Required Permissions
```xml
INTERNET                    - API calls
ACCESS_FINE_LOCATION        - Qibla & Prayer times
ACCESS_COARSE_LOCATION      - Location services
RECEIVE_BOOT_COMPLETED      - Persistent alarms
VIBRATE                     - Alarm vibration
SCHEDULE_EXACT_ALARM        - Exact timing
POST_NOTIFICATIONS          - Notifications
```

## 🧪 Testing Strategy

### Unit Tests
- Controller logic
- API service responses
- Data model parsing

### Widget Tests
- Page rendering
- User interactions
- State changes

### Integration Tests
- End-to-end flows
- API integration
- Storage operations

## 📱 Build Configuration

### Android
- **minSdk**: 21 (Android 5.0)
- **targetSdk**: 34 (Android 14)
- **compileSdk**: 34

### Build Commands
```bash
# Development
flutter run

# Release APK
flutter build apk --release

# Release App Bundle
flutter build appbundle --release
```

## 🚀 Performance Optimization

1. **Lazy Loading**: GetX lazy loading for controllers
2. **Caching**: Aggressive caching for offline access
3. **Image Optimization**: Compressed assets
4. **Code Splitting**: Feature-based modules
5. **Debouncing**: Search and filter operations

## 🔮 Future Enhancements

- [ ] Audio Quran recitation
- [ ] Prayer time widget
- [ ] Tasbih counter
- [ ] Islamic calendar
- [ ] Mosque finder
- [ ] Daily dhikr reminders
- [ ] Multi-language support
- [ ] Cloud sync
- [ ] User notes and bookmarks
- [ ] Sharing to social media

---

This structure follows **Clean Architecture** and **SOLID** principles for maintainability and scalability.
