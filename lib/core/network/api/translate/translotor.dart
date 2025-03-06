import 'dart:developer';

import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:translator/translator.dart';

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

  static Future<String> translated({required String message}) async {
    final translator = GoogleTranslator();
    try {
      Translation value =
          await translator.translate(message, from: 'en', to: 'ar');
      return value.text;
    } catch (e, stackTrace) {
      log("Translation Error: ${e.toString()}\n$stackTrace");

      // Return original message instead of failing completely
      return message;
    }
  }
}
