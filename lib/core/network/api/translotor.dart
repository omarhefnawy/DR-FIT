import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class Translator {
  static final modelManager = OnDeviceTranslatorModelManager();
  static bool _modelsDownloaded = false;

  static Future<void> initialize() async {
    if (!_modelsDownloaded) {
      await modelManager.downloadModel(TranslateLanguage.english.bcpCode);
      await modelManager.downloadModel(TranslateLanguage.arabic.bcpCode);
      _modelsDownloaded = true;
    }
  }

  static Future<String> translate({required String message}) async {
    await initialize();
    final onDeviceTranslator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: TranslateLanguage.arabic,
    );

    final String response = await onDeviceTranslator.translateText(message);
    onDeviceTranslator.close();
    return response;
  }
}
