import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  // Singleton Pattern
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  final FlutterTts _flutterTts = FlutterTts();

  Future<TtsService> init() async {
    await _initTts();
    return this;
  }

  Future<void> _initTts() async {
    try {
      bool isArSaAvailable = await _flutterTts.isLanguageAvailable("ar-SA");
      await _flutterTts.setLanguage(isArSaAvailable ? 'ar-SA' : 'ar');
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);

      final List<dynamic>? voices = await _flutterTts.getVoices;
      if (voices != null) {
        final arVoices = voices
            .where((v) =>
                v['locale'].toString().startsWith('ar-SA') ||
                v['locale'].toString().startsWith('ar'))
            .toList();

        var maleVoice = arVoices.firstWhere(
          (v) {
            final name = v['name'].toString().toLowerCase();
            return name.contains('male') ||
                name.contains('man') ||
                name.contains('low') ||
                name.contains('b-') ||
                name.contains('d-');
          },
          orElse: () => null,
        );

        if (maleVoice != null) {
          await _flutterTts.setVoice(
              {"name": maleVoice['name'], "locale": maleVoice['locale']});
        } else if (arVoices.isNotEmpty) {
          var fallbackVoice = arVoices.last;
          await _flutterTts.setVoice({
            "name": fallbackVoice['name'],
            "locale": fallbackVoice['locale']
          });
          await _flutterTts.setPitch(0.8);
        }
      }
    } catch (e) {
      // log error
    }
  }

  void setHandlers({
    required Function() onStart,
    required Function() onComplete,
    required Function(dynamic) onError,
  }) {
    _flutterTts.setStartHandler(onStart);
    _flutterTts.setCompletionHandler(onComplete);
    _flutterTts.setErrorHandler(onError);
  }

  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}
