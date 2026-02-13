import 'package:get/get.dart';
import '../../../../core/storage/local_storage.dart';
import '../data/hadith_model.dart';

class HadithController extends GetxController {
  final LocalStorage _storageService = Get.find();

  final RxList<HadithBook> books = <HadithBook>[].obs;
  final RxList<Hadith> currentHadiths = <Hadith>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingHadiths = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<HadithBook?> currentBook = Rx<HadithBook?>(null);

  @override
  void onInit() {
    super.onInit();
    loadHadithBooks();
  }

  Future<void> loadHadithBooks() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Check if data exists in cache
      if (_storageService.hasHadithData()) {
        books.value = _storageService.getHadithBooks();
        isLoading.value = false;
        return;
      }

      // Fetch from API
      final fetchedBooks = await _fetchHadithBooks();
      await _storageService.saveHadithBooks(fetchedBooks);
      books.value = fetchedBooks;

      // Cache some hadiths for offline use
      for (var book in fetchedBooks) {
        final hadiths = await _fetchHadiths(book.id);
        await _storageService.saveHadiths(book.id, hadiths);
      }
    } catch (e) {
      errorMessage.value = 'হাদিস লোড করতে সমস্যা হয়েছে: ${e.toString()}';
      // log error
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadHadiths(HadithBook book) async {
    try {
      isLoadingHadiths.value = true;
      currentBook.value = book;

      // Load from cache first
      var hadiths = _storageService.getHadiths(book.id);

      // If no hadiths in cache, fetch from API
      if (hadiths.isEmpty) {
        hadiths = await _fetchHadiths(book.id);
        await _storageService.saveHadiths(book.id, hadiths);
      }

      currentHadiths.value = hadiths;
    } catch (e) {
      errorMessage.value = 'হাদিস লোড করতে সমস্যা হয়েছে: ${e.toString()}';
      // log error
    } finally {
      isLoadingHadiths.value = false;
    }
  }

  // Fetch Hadith Books (Mock data since we need Bangla Hadith)
  Future<List<HadithBook>> _fetchHadithBooks() async {
    // Mock Hadith books data in Bangla
    return [
      HadithBook(
        id: 'bukhari',
        name: 'সহীহ বুখারী',
        writerName: 'ইমাম বুখারী',
        numberOfHadith: 7563,
      ),
      HadithBook(
        id: 'muslim',
        name: 'সহীহ মুসলিম',
        writerName: 'ইমাম মুসলিম',
        numberOfHadith: 7190,
      ),
      HadithBook(
        id: 'abudawud',
        name: 'সুনান আবু দাউদ',
        writerName: 'ইমাম আবু দাউদ',
        numberOfHadith: 5274,
      ),
      HadithBook(
        id: 'tirmidhi',
        name: 'জামে তিরমিযী',
        writerName: 'ইমাম তিরমিযী',
        numberOfHadith: 3956,
      ),
      HadithBook(
        id: 'nasai',
        name: 'সুনান নাসাঈ',
        writerName: 'ইমাম নাসাঈ',
        numberOfHadith: 5758,
      ),
      HadithBook(
        id: 'ibnmajah',
        name: 'সুনান ইবনে মাজাহ',
        writerName: 'ইমাম ইবনে মাজাহ',
        numberOfHadith: 4341,
      ),
    ];
  }

  // Fetch Hadiths from a specific book (Mock data)
  Future<List<Hadith>> _fetchHadiths(String bookId) async {
    // Mock Hadith data - In a real app, this would come from an API
    final mockHadiths = <Hadith>[];

    for (int i = 1; i <= 20; i++) {
      mockHadiths.add(Hadith(
        id: '${bookId}_$i',
        bookId: bookId,
        hadithNumber: i,
        text: _getMockHadithText(bookId, i),
        narrator: _getMockNarrator(i),
        category: _getMockCategory(i),
      ));
    }

    return mockHadiths;
  }

  String _getMockHadithText(String bookId, int number) {
    final texts = [
      'আল্লাহর রাসূল (সা.) বলেছেন: "মুসলমান সেই, যার মুখ ও হাত থেকে অন্য মুসলমানগণ নিরাপদ থাকে।"',
      'নবী করীম (সা.) বলেন: "নিশ্চয়ই সকল আমল নিয়তের উপর নির্ভরশীল এবং প্রত্যেক ব্যক্তি তার নিয়ত অনুযায়ী ফল পাবে।"',
      'রাসূলুল্লাহ (সা.) বলেছেন: "মায়ের পায়ের নিচে সন্তানের জান্নাত।"',
      'নবীজি (সা.) বলেন: "উত্তম মুসলমান সেই ব্যক্তি যে অন্যের জন্য তাই পছন্দ করে যা নিজের জন্য পছন্দ করে।"',
      'আল্লাহর রাসূল (সা.) বলেছেন: "জ্ঞান অর্জন করা প্রত্যেক মুসলিম নর-নারীর উপর ফরজ।"',
      'নবী করীম (সা.) বলেন: "যে ব্যক্তি মানুষকে ধন্যবাদ জানায় না, সে আল্লাহকেও ধন্যবাদ জানায় না।"',
      'রাসূলুল্লাহ (সা.) বলেছেন: "আল্লাহর নিকট সবচেয়ে প্রিয় আমল হলো নিয়মিত আমল, যদিও তা অল্প হয়।"',
      'নবীজি (সা.) বলেন: "হাসিমুখে তোমার ভাইয়ের সাথে সাক্ষাৎ করাও একটি সদকা।"',
      'আল্লাহর রাসূল (সা.) বলেছেন: "প্রকৃত বীর সেই নয় যে কুস্তিতে জয়ী হয়, বরং প্রকৃত বীর সেই যে রাগের সময় নিজেকে নিয়ন্ত্রণ করতে পারে।"',
      'নবী করীম (সা.) বলেন: "যে ব্যক্তি কোনো অসুবিধায় পতিত মুসলমানের অসুবিধা দূর করবে, আল্লাহ তার দুনিয়া ও আখিরাতের অসুবিধা দূর করবেন।"',
    ];

    return texts[number % texts.length];
  }

  String _getMockNarrator(int number) {
    final narrators = [
      'আবু হুরায়রা (রা.)',
      'আয়েশা (রা.)',
      'আবদুল্লাহ ইবনে উমর (রা.)',
      'আনাস ইবনে মালিক (রা.)',
      'আবদুল্লাহ ইবনে মাসউদ (রা.)',
    ];
    return narrators[number % narrators.length];
  }

  String _getMockCategory(int number) {
    final categories = [
      'ঈমান',
      'ইবাদত',
      'আখলাক',
      'সামাজিক',
      'জ্ঞান',
    ];
    return categories[number % categories.length];
  }

  Future<void> refreshHadithData() async {
    await loadHadithBooks();
  }
}
