// ignore_for_file: avoid_print

import 'package:arrowspeed/core/app_router/app_router.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:arrowspeed/featuers/auth/data/models/user_model.dart';
import 'package:arrowspeed/featuers/auth/data/repo_imp/user_reop_im.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final UserRepoImpl _userRepository;

  // Controllers
  final loginEmailController = TextEditingController();
  final passwordController = TextEditingController();

  // Errors
  final loginEmailError = Rxn<String>();
  final passwordError = Rxn<String>();

  // State
  var email = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;

  LoginController(this._userRepository);

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
    resetForm();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      Get.offAllNamed('/home');
    }
  }

  // Validation
  String? validateLoginEmail(String? value) {
    if (value == null || value.isEmpty) {
      return Utils.localize('PleaseEnterYourEmail');
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return Utils.localize('InvalidEmailFormat');
    }
    return null;
  }

  // String? validateLoginEmail(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return Utils.localize('PleaseEnterYourEmail');
  //   } else if (!RegExp(r'^[\w-]+(\.[\w-])').hasMatch(value)) {
  //     return Utils.localize('EmailMustBeArrowspeed');
  //   }
  //   return null;
  // }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return Utils.localize('PleaseEnterYourPassword');
    }
    return null;
  }

  void validateField(TextEditingController controller,
      String? Function(String) validator, Rx<String?> error) {
    final errorMessage = validator(controller.text);
    error.value = errorMessage;
  }

  bool _validateAll() {
    loginEmailError.value = validateLoginEmail(loginEmailController.text);
    passwordError.value = validatePassword(passwordController.text);

    return loginEmailError.value == null && passwordError.value == null;
  }

  // Future<void> login() async {
  //   if (!_validateAll()) return;

  //   isLoading.value = true;

  //   try {
  //     UserModel? user = await _userRepository.login(
  //         loginEmailController.text, passwordController.text);

  //     if (user != null) {
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       await prefs.setString('userId', user.id!); // حفظ userId هنا
  //       await prefs.setBool('isLoggedIn', true);

  //       Get.snackbar("نجاح", "تم تسجيل الدخول بنجاح 🎉",
  //           backgroundColor: Get.theme.primaryColor);
  //       print(user.toJson());
  //       await Future.delayed(Duration(seconds: 2));
  //       Get.offAllNamed(AppRouter.mainHome);
  //     } else {
  //       Get.snackbar("خطأ", "بيانات الدخول غير صحيحة",
  //           backgroundColor: Colors.red);
  //     }
  //   } catch (e) {
  //     Get.snackbar("خطأ", "حدث خطأ غير متوقع: $e", backgroundColor: Colors.red);
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  Future<void> login() async {
    if (!_validateAll()) return;

    isLoading.value = true;

    try {
      UserModel? user = await _userRepository.login(
          loginEmailController.text, passwordController.text);

      if (user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', user.id!); // حفظ userId
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('loginEmail', user.loginEmail);

        Get.snackbar("نجاح", "تم تسجيل الدخول بنجاح 🎉",
            backgroundColor: Get.theme.primaryColor);
        print(user.toJson());

        await Future.delayed(Duration(seconds: 2));

        if (user.loginEmail.endsWith('@admin.com')) {
          Get.offAllNamed(AppRouter.adminHome);
        } else {
          Get.offAllNamed(AppRouter.mainHome);
        }
      } else {
        Get.snackbar("خطأ", "بيانات الدخول غير صحيحة",
            backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ غير متوقع: $e", backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  void resetForm() {
    loginEmailController.clear();
    passwordController.clear();
    loginEmailError.value = null;
    passwordError.value = null;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    Get.offAllNamed(AppRouter.splash);
  }
}
