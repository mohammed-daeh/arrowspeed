// // ignore_for_file: avoid_print

// import 'package:arrowspeed/featuers/auth/data/repositories/user_reop_im.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ProfileController extends GetxController {
//   final UserRepoImpl _repoImpl;

//   ProfileController(this._repoImpl);

//   var firstName = ''.obs;
//   var lastName = ''.obs;
//   var email = ''.obs;
//   var image = ''.obs;
//   var isLoading = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     loadUserData();
//   }

//   Future<void> loadUserData() async {
//     try {
//       isLoading(true);

//       // استرجاع userId من `SharedPreferences`
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? userId = prefs.getString("userId");

//       if (userId == null) {
//         print("❌ لم يتم العثور على userId!");
//         return;
//       }

//       // جلب بيانات المستخدم
//       var user = await _repoImpl.getUserData(userId);

//       if (user != null) {
//         firstName.value = user.firstName;
//         lastName.value = user.lastName;
//         email.value = user.loginEmail;
//         image.value = user.profilePhoto;
//       }
//     } catch (e) {
//       print("❌ خطأ أثناء جلب بيانات المستخدم: $e");
//     } finally {
//       isLoading(false);
//     }
//   }
// }
