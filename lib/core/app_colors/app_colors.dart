import 'package:flutter/material.dart';

class AppColors {
  static Color white = Colors.white;
  static Color black = Colors.black;
  static Color transparent = Colors.transparent;
  static Color grey = Color(0xFFE0E0E0);
  static Color greyback = Color(0xFFF0F1F3);
  static Color grey1 = Color(0xFFE0E0E0);
  static Color oxfordBlue = Color(0xFF042F40);
  static Color red = Color(0xFFF44336);
  static Color yallow = Color(0xFFFAC763);
  //////
  // static const Color white = Color(0xFFFFFFFF);
  // static const Color black = Color(0xFF000000);
  // static const Color transparent = Color(0x00000000);
  // static const Color grey = Color(0xFFE0E0E0);
  static const Color greyIconForm = Color(0xFFA3A3A3);
  static const Color greyHintForm = Color(0xFFCCCCCC);
  // static const Color grey1 = Color(0xFFE0E0E0);
  static const Color greyborder = Color(0xffB3B5CC);
  // static const Color oxfordBlue = Color(0xFF042F40);
  static const Color prussianBlue = Color(0xFF03314B);
  static const Color mountainMeadow = Color(0xFF1FBF83);
  static const Color zomp = Color(0xFF36A690);
  // static const Color red = Color(0xFFF44336);

  // ألوان الثيم الفاتح
  static Color lightBackground = Colors.white;
  static Color lightTextColor = Colors.black;
  static Color lightContainerColor = Colors.white;
  static Color lightTextColorContent = Colors.black;

  // ألوان الثيم الداكن
  static Color darkBackground = Colors.black;
  static Color darkTextColor = Colors.white;
  static Color darkContainerColor = Colors.black;
  static Color darkTextColorContent = Colors.white;

  // تحديث الألوان بناءً على الثيم
  static void updateTheme(bool isDarkMode) {
    if (isDarkMode) {
      white = darkContainerColor;
      black = darkTextColor;
      grey = Color(0xFF616161); // لون رمادي للثيم الداكن
      oxfordBlue = Color(0xFF1A1A1A); // تغيير اللون في الثيم الداكن
    } else {
      white = lightContainerColor;
      black = lightTextColor;
      grey = Color(0xFFE0E0E0); // اللون الرمادي للثيم الفاتح
      oxfordBlue = Color(0xFF042F40); // الألوان الأصلية للثيم الفاتح
    }
  }
}

// import 'package:flutter/material.dart';

// class AppColors {
//   static const Color white = Color(0xFFFFFFFF);
//   static const Color black = Color(0xFF000000);
//   static const Color transparent = Color(0x00000000);
//   static const Color grey = Color(0xFFE0E0E0);
//   static const Color greyIconForm = Color(0xFFA3A3A3);
//   static const Color greyHintForm = Color(0xFFCCCCCC);
//   static const Color grey1 = Color(0xFFE0E0E0);
//   static const Color greyborder = Color(0xffB3B5CC);
//   static const Color oxfordBlue = Color(0xFF042F40);
//   static const Color prussianBlue = Color(0xFF03314B);
//   static const Color mountainMeadow = Color(0xFF1FBF83);
//   static const Color zomp = Color(0xFF36A690);
//   static const Color red = Color(0xFFF44336);
// }
