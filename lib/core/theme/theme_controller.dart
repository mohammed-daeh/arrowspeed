// ignore_for_file: deprecated_member_use

import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ThemeController extends GetxController {
  RxBool isDarkMode = false.obs;  

  void setTheme(int themeIndex) {
    if (themeIndex == 0) {
      final brightness = WidgetsBinding.instance.window.platformBrightness;
      isDarkMode.value = brightness == Brightness.dark;
    } else if (themeIndex == 1) {
      isDarkMode.value = false;
    } else if (themeIndex == 2) {
      isDarkMode.value = true;
    }
  }
}
