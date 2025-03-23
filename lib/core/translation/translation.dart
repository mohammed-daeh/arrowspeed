

// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Utils {
  static Map<String, Map<String, String>> _translations = {};
  static String _currentLanguage = 'en';

  static Future<void> loadTranslations(String filePath) async {
    String jsonString = await rootBundle.loadString(filePath);
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _translations = jsonMap.map((key, value) {
      return MapEntry(key, Map<String, String>.from(value));
    });
  }

  static void changeLanguage(String languageCode) {
    if (_translations.containsKey(languageCode)) {
      _currentLanguage = languageCode;
      Get.updateLocale(Locale(languageCode));
    } else {
      print("Language not found: $languageCode");
    }
  }

  static String localize(String key) {
    return _translations[_currentLanguage]?[key] ?? key;
  }

  static String get currentLanguage => _currentLanguage;

  static String getLanguage() {
    return _currentLanguage;
  }

  static TextDirection getTextDirection() {
    return _currentLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr;
  }
}
