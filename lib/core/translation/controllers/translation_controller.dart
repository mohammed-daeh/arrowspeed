import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class TranslationController extends GetxController {
  var currentLanguage = 'en'.obs;
  Map<String, Map<String, String>> _translations = {};

  @override
  void onInit() {
    super.onInit();
    loadSavedLanguage();
    loadTranslations(); 
  }

  Future<void> loadTranslations() async {
    String jsonString = await rootBundle.loadString('assets/translations.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _translations = jsonMap.map((key, value) {
      return MapEntry(key, Map<String, String>.from(value));
    });

    update(); 
  }

  void changeLanguage(String languageCode) async {
    if (_translations.containsKey(languageCode)) {
      currentLanguage.value = languageCode;
      Get.updateLocale(Locale(languageCode));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('language', languageCode);

      update(); 
    }
  }

  void loadSavedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLanguage = prefs.getString('language');

    currentLanguage.value = savedLanguage!;
    Get.updateLocale(Locale(savedLanguage));
    }

  String localize(String key) {
    return _translations[currentLanguage.value]?[key] ?? key;
  }
}
