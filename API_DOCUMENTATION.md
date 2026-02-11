# API Documentation

This document describes all the APIs used in the Islamic mobile application and how to work with them.

## 📡 API Overview

The app uses two main external APIs:

1. **Al-Quran Cloud API** - For Quran data
2. **Random Hadith Generator API** - For Hadith collections

## 1️⃣ Al-Quran Cloud API

### Base URL
```
https://api.alquran.cloud/v1
```

### Endpoints Used

#### 1.1 Get All Surahs

**Endpoint**: `GET /surah`

**Description**: Retrieves the list of all 114 Surahs with basic information.

**Response Example**:
```json
{
  "code": 200,
  "status": "OK",
  "data": [
    {
      "number": 1,
      "name": "سُورَةُ ٱلْفَاتِحَةِ",
      "englishName": "Al-Faatiha",
      "englishNameTranslation": "The Opening",
      "numberOfAyahs": 7,
      "revelationType": "Meccan"
    },
    ...
  ]
}
```

**Implementation**:
```dart
Future<List<SurahModel>> getAllSurahs() async {
  final response = await http.get(
    Uri.parse('$baseUrl/surah'),
  );
  
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final List surahs = data['data'];
    return surahs.map((surah) => SurahModel.fromJson(surah)).toList();
  }
  throw Exception('Failed to load surahs');
}
```

#### 1.2 Get Surah with Arabic Text

**Endpoint**: `GET /surah/{surahNumber}`

**Parameters**:
- `surahNumber` (path) - Surah number (1-114)

**Response Example**:
```json
{
  "code": 200,
  "status": "OK",
  "data": {
    "number": 1,
    "name": "سُورَةُ ٱلْفَاتِحَةِ",
    "englishName": "Al-Faatiha",
    "numberOfAyahs": 7,
    "ayahs": [
      {
        "number": 1,
        "numberInSurah": 1,
        "text": "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ"
      },
      ...
    ]
  }
}
```

#### 1.3 Get Surah with Translation

**Endpoint**: `GET /surah/{surahNumber}/{edition}`

**Parameters**:
- `surahNumber` (path) - Surah number (1-114)
- `edition` (path) - Translation edition identifier

**Available Editions**:
- `bn.bengali` - Bangla translation (Muhiuddin Khan)
- `en.sahih` - English translation (Sahih International)
- `ar.alafasy` - Arabic (default)

**Example**:
```
GET /surah/1/bn.bengali
```

**Response Example**:
```json
{
  "code": 200,
  "status": "OK",
  "data": {
    "number": 1,
    "name": "سُورَةُ ٱلْفَاتِحَةِ",
    "englishName": "Al-Faatiha",
    "ayahs": [
      {
        "number": 1,
        "numberInSurah": 1,
        "text": "পরম করুণাময় অসীম দয়ালু আল্লাহর নামে"
      },
      ...
    ]
  }
}
```

### Error Handling

**Error Response**:
```json
{
  "code": 400,
  "status": "Bad Request",
  "data": "Invalid Surah number"
}
```

**Common Errors**:
- `400` - Invalid parameters
- `404` - Surah not found
- `500` - Server error

### Rate Limits

- No official rate limit
- Recommended: 1 request per second
- Implemented caching to minimize requests

### Implementation in App

```dart
// Combine Arabic, Bangla, and English
Future<Map<String, dynamic>> getSurahComplete(int surahNumber) async {
  final arabicData = await getSurahArabic(surahNumber);
  final banglaData = await getSurahBangla(surahNumber);
  final englishData = await getSurahEnglish(surahNumber);
  
  List<Map<String, dynamic>> combinedAyahs = [];
  
  for (int i = 0; i < arabicData['ayahs'].length; i++) {
    combinedAyahs.add({
      'number': arabicData['ayahs'][i]['number'],
      'numberInSurah': arabicData['ayahs'][i]['numberInSurah'],
      'arabic': arabicData['ayahs'][i]['text'],
      'bangla': banglaData['ayahs'][i]['text'],
      'english': englishData['ayahs'][i]['text'],
    });
  }
  
  return {
    'number': arabicData['number'],
    'name': arabicData['name'],
    'englishName': arabicData['englishName'],
    'ayahs': combinedAyahs,
  };
}
```

## 2️⃣ Random Hadith Generator API

### Base URL
```
https://random-hadith-generator.vercel.app
```

### Endpoints Used

#### 2.1 Get Random Hadith

**Endpoint**: `GET /{collection}`

**Parameters**:
- `collection` (path) - Hadith collection name

**Available Collections**:
- `bukhari` - Sahih Bukhari
- `muslim` - Sahih Muslim
- `abudawud` - Sunan Abu Dawud
- `tirmidhi` - Jami At-Tirmidhi
- `nasai` - Sunan An-Nasa'i
- `ibnmajah` - Sunan Ibn Majah

**Example**:
```
GET /bukhari
```

**Response Example**:
```json
{
  "status": {
    "code": 200,
    "message": "Success"
  },
  "data": {
    "hadithNumber": "1",
    "englishNarrator": "Umar bin Al-Khattab",
    "hadithEnglish": "I heard Allah's Messenger saying...",
    "hadithArabic": "عَنْ عُمَرَ بْنِ الْخَطَّابِ قَالَ سَمِعْتُ رَسُولَ اللَّهِ",
    "book": {
      "bookName": "The Book of Revelation",
      "bookNumber": "1",
      "hadithStartNumber": 1,
      "hadithEndNumber": 7,
      "numberOfHadith": 7
    },
    "chapter": {
      "chapterNumber": "1",
      "chapterEnglish": "How the Divine Inspiration started",
      "chapterArabic": "بَدْءِ الْوَحْىِ"
    }
  }
}
```

### Error Handling

**Error Response**:
```json
{
  "status": {
    "code": 404,
    "message": "Not Found"
  }
}
```

**Common Errors**:
- `404` - Collection not found
- `500` - Server error

### Rate Limits

- No strict rate limits
- Recommendation: Add delay between requests
- Implemented: 500ms delay between calls

### Implementation in App

```dart
Future<Map<String, dynamic>> getRandomHadith(String bookId) async {
  final response = await http.get(
    Uri.parse('$baseUrl/$bookId'),
  );
  
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return {
      'hadithNumber': data['data']['hadithNumber'] ?? '',
      'englishNarrator': data['data']['englishNarrator'] ?? '',
      'hadithEnglish': data['data']['hadithEnglish'] ?? '',
      'hadithArabic': data['data']['hadithArabic'] ?? '',
      'book': data['data']['book'] ?? {},
      'chapter': data['data']['chapter'] ?? {},
    };
  }
  throw Exception('Failed to load hadith');
}

// Get multiple hadiths with delay
Future<List<Map<String, dynamic>>> getHadithsFromBook(
  String bookId,
  int count,
) async {
  List<Map<String, dynamic>> hadiths = [];
  
  for (int i = 0; i < count; i++) {
    final hadith = await getRandomHadith(bookId);
    hadiths.add(hadith);
    await Future.delayed(const Duration(milliseconds: 500));
  }
  
  return hadiths;
}
```

## 📦 Local Caching Strategy

### Cache Implementation

```dart
// Check cache before API call
Future<Map<String, dynamic>?> getSurahDetail(int surahNumber) async {
  final cacheKey = 'surah_$surahNumber';
  
  // Check cache first
  if (_storageService.hasQuranCache(cacheKey)) {
    final cachedData = _storageService.getQuranCache(cacheKey);
    return json.decode(cachedData);
  }
  
  // Fetch from API if not cached
  final surahData = await _apiService.getSurahComplete(surahNumber);
  
  // Save to cache
  await _storageService.cacheQuranData(
    cacheKey,
    json.encode(surahData),
  );
  
  return surahData;
}
```

### Cache Keys

**Quran**:
- `surahs_list` - All surahs metadata
- `surah_{number}` - Individual surah with translations (1-114)

**Hadith**:
- `hadith_{bookId}` - Hadith collection data
  - Example: `hadith_bukhari`, `hadith_muslim`

### Cache Storage

- **Technology**: Hive (NoSQL database)
- **Location**: App's private storage
- **Format**: JSON strings
- **Persistence**: Survives app restarts

## 🔄 Offline-First Architecture

### Flow Diagram

```
User Request
    ↓
Check Cache Exists?
    ↓
Yes → Return Cached Data (Fast)
    ↓
No → Fetch from API
    ↓
Save to Cache
    ↓
Return Fresh Data
```

### Benefits

1. **Fast Loading**: Cached data loads instantly
2. **Offline Access**: Works without internet
3. **Reduced Bandwidth**: Fewer API calls
4. **Better UX**: No loading delays after first load

## 🛡️ Error Handling

### Network Errors

```dart
try {
  final data = await apiService.getData();
  return data;
} catch (e) {
  if (e is SocketException) {
    // No internet connection
    return getCachedData();
  } else if (e is TimeoutException) {
    // Request timeout
    throw Exception('Request timeout');
  } else {
    // Other errors
    throw Exception('Error: $e');
  }
}
```

### API Response Errors

```dart
if (response.statusCode == 200) {
  return processData(response.body);
} else if (response.statusCode == 404) {
  throw Exception('Resource not found');
} else if (response.statusCode == 500) {
  throw Exception('Server error');
} else {
  throw Exception('Unexpected error: ${response.statusCode}');
}
```

## 📊 API Performance

### Optimization Techniques

1. **Caching**: Aggressive caching to minimize requests
2. **Batch Loading**: Load multiple resources in parallel
3. **Pagination**: Load data in chunks (if needed)
4. **Compression**: Use gzip for responses
5. **Retry Logic**: Automatic retry on failure

### Sample Implementation

```dart
Future<void> loadSurahsInParallel() async {
  final futures = <Future>[];
  
  for (int i = 1; i <= 114; i++) {
    futures.add(getSurahDetail(i));
    
    // Load in batches of 10
    if (i % 10 == 0) {
      await Future.wait(futures);
      futures.clear();
    }
  }
  
  // Load remaining
  if (futures.isNotEmpty) {
    await Future.wait(futures);
  }
}
```

## 🔍 Testing APIs

### Using curl

```bash
# Get all surahs
curl https://api.alquran.cloud/v1/surah

# Get specific surah
curl https://api.alquran.cloud/v1/surah/1

# Get surah with translation
curl https://api.alquran.cloud/v1/surah/1/bn.bengali

# Get random hadith
curl https://random-hadith-generator.vercel.app/bukhari
```

### Using Postman

1. Import collection from URL
2. Set base URLs as variables
3. Create tests for each endpoint
4. Monitor response times

## 📝 API Limitations

### Al-Quran Cloud API

**Limitations**:
- No authentication required
- Public access
- May have rate limits (undocumented)
- No guaranteed uptime SLA

**Recommendations**:
- Always cache data
- Implement fallback mechanisms
- Handle errors gracefully

### Random Hadith Generator API

**Limitations**:
- Returns random hadith only
- No specific hadith retrieval by number
- Limited to 6 collections
- No Bangla translation available

**Recommendations**:
- Cache fetched hadiths
- Load multiple hadiths on first access
- Implement delay between requests

## 🔮 Future Enhancements

### Potential API Integrations

1. **Prayer Times API**
   - Aladhan API
   - Muslim Pro API
   
2. **Audio Quran**
   - Quran.com audio API
   - EveryAyah.com

3. **Islamic Calendar**
   - HijriCalendar API

4. **Mosque Finder**
   - Google Places API
   - OpenStreetMap

5. **Tafsir (Commentary)**
   - Tafsir API
   - Quran.com Tafsir

## 📚 Additional Resources

- [Al-Quran Cloud API Docs](https://alquran.cloud/api)
- [Hadith API GitHub](https://github.com/fawazahmed0/hadith-api)
- [HTTP Package Docs](https://pub.dev/packages/http)
- [Dio Package Docs](https://pub.dev/packages/dio)

---

**Note**: Always respect API terms of service and usage limits. Implement proper error handling and caching to provide the best user experience.
