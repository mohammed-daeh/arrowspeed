// import 'package:shared_preferences/shared_preferences.dart';

// class SharedPrefs {
//   static const String _userIdKey = 'userId';

//   // حفظ userId عند تسجيل الدخول
//   Future<void> saveUserId(String userId) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_userIdKey, userId);
//   }

//   // الحصول على userId المخزن
//   Future<String> getUserId() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_userIdKey) ?? '';
//   }
// }