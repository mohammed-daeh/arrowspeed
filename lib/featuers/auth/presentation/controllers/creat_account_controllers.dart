// ignore_for_file: avoid_print

import 'package:arrowspeed/core/app_router/app_router.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:arrowspeed/featuers/auth/data/models/user_model.dart';
import 'package:arrowspeed/featuers/auth/data/repo_imp/user_reop_im.dart';
import 'package:arrowspeed/featuers/auth/domin/entities/user.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateAccountController extends GetxController {
  final UserRepoImpl _userRepoImpl;

  CreateAccountController(this._userRepoImpl);

  // Controllers
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email =
      TextEditingController(); 
  final gmail = TextEditingController(); 
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final mobilNumber = TextEditingController();
  final selectedGender = Rxn<String>();

  // Errors
  final firstNameError = Rxn<String>();
  final lastNameError = Rxn<String>();
  final emailError = Rxn<String>();
  final gmailError = Rxn<String>();
  final passwordError = Rxn<String>();
  final confirmPasswordError = Rxn<String>();
  final mobileNumberError = Rxn<String>();
  final genderError = Rxn<String>();

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    resetForm(); 
  }

  // Validation
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return Utils.localize('PleaseEnterName');
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return Utils.localize('PleaseEnterYourEmail');
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@arrowspeed\.com$')
        .hasMatch(value)) {
      return Utils.localize(
          'EmailMustBeArrowspeed'); 
    }
    return null;
  }

  String? validateGmail(String? value) {
    if (value == null || value.isEmpty) {
      return Utils.localize('PleaseEnterYourGmail');
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@gmail\.com$').hasMatch(value)) {
      return Utils.localize('EmailMustBeGmail'); 
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return Utils.localize('PleaseEnterYourPassword');
    } else if (value.length < 6) {
      return Utils.localize('PasswordMustBeAtLeast');
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value != password.text) {
      return Utils.localize('PasswordDoesNotMatch');
    }
    return null;
  }

  String? validateMobile(String? value) {
    if (value == null || value.length < 9) {
      return Utils.localize('InvalidPhoneNumber');
    }
    return null;
  }

  String? validateGender() {
    if (selectedGender.value == null) {
      return Utils.localize('PleaseSelectGender');
    }
    return null;
  }

  void validateField(TextEditingController controller,
      String? Function() validator, Rx<String?> error) {
    final errorMessage = validator();
    error.value = errorMessage;
  }

  bool _validateAll() {
    final validations = [
      validateName(firstName.text),
      validateName(lastName.text),
      validateEmail(email.text),
      validateGmail(gmail.text),
      validatePassword(password.text),
      validateConfirmPassword(confirmPassword.text),
      validateMobile(mobilNumber.text),
      validateGender(),
    ];

    [
      firstNameError,
      lastNameError,
      emailError,
      gmailError,
      passwordError,
      confirmPasswordError,
      mobileNumberError,
      genderError,
    ].asMap().forEach((index, error) {
      error.value = validations[index];
    });

    final isValid = validations.every((v) => v == null);
    print("✅ هل جميع الحقول صحيحة؟ $isValid");

    return isValid;
  }

  Future<void> createUser() async {
    if (!_validateAll()) {
      print("❌ المدخلات غير صحيحة، لن يتم إنشاء المستخدم!");
      return;
    }

    isLoading(true);
    print("🔄 جاري إنشاء الحساب...");

    final user = UserModel(
      passwordHash: password.text,
      firstName: firstName.text,
      lastName: lastName.text,
      loginEmail: email.text.trim(),
      authEmail: gmail.text.trim(),
      phoneNumber: mobilNumber.text.trim(),
      gender:
          selectedGender.value == 'male' ? UserGender.male : UserGender.female,
      profilePhoto: '',
      isVerified: false,
      isLogin: false,
    );

    print("🆕 بيانات المستخدم: ${user.toJson()}");

    try {
      bool emailExists =
          await _userRepoImpl.checkIfEmailExists(user.loginEmail);
      if (emailExists) {
        print("⚠️ الحساب موجود بالفعل! لا يمكن إنشاء الحساب.");
        Get.snackbar(
          "خطأ",
          "البريد الإلكتروني مسجل مسبقًا، يرجى تسجيل الدخول أو استخدام بريد آخر.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return; 
      }

      String userId = await _userRepoImpl.createUser(user);

      if (userId.isEmpty) {
        throw "❌ لم يتم إنشاء المستخدم بشكل صحيح!";
      }

      print("✅ تم إنشاء المستخدم بنجاح! ID: $userId");
SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("userId", userId);

      String? otp = await _waitForOtp(userId);

      if (otp != null) {
        print("📩 إرسال إشعار برمز التحقق...");
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 1,
            channelKey: 'basic_channel',
            title: 'رمز التحقق الخاص بك',
            body: 'رمز التحقق هو: $otp',
            notificationLayout: NotificationLayout.Default,
          ),
        );
      } else {
        print("❌ لم يتم العثور على رمز التحقق بعد انتهاء المهلة!");
      }

      print(
          "➡️ الانتقال إلى صفحة التحقق مع: userId = $userId, loginEmail = ${email.text}");

      
      Get.offAllNamed(
        AppRouter.otp,
        arguments: {
          'userId': userId,
          'loginEmail': email.text
        },
      );
      resetForm();
    } catch (e) {
      print("❌ خطأ أثناء إنشاء المستخدم: $e");
      Get.snackbar(Utils.localize('Error'), e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<String?> _waitForOtp(String userId) async {
    const int timeoutMs = 5000; 
    const int delayMs = 500; 
    int elapsedTime = 0;

    while (elapsedTime < timeoutMs) {
      String? otp = await _userRepoImpl.getOtp(userId);
      if (otp != null) {
        print("🔢 تم العثور على OTP: $otp");
        return otp;
      }
      await Future.delayed(Duration(milliseconds: delayMs));
      elapsedTime += delayMs;
    }

    return null; 
  }

  Future<void> fetchOtpAndNotify(String userId) async {
    String? otp = await _userRepoImpl.getOtp(userId);
    if (otp != null) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: 'basic_channel',
          title: 'رمز التحقق الخاص بك',
          body: 'رمز التحقق هو: $otp',
          notificationLayout: NotificationLayout.Default,
        ),
      );
    } else {
      print("❌ لم يتم العثور على رمز التحقق!");
    }
  }

  void resetForm() {
    firstName.clear();
    lastName.clear();
    email.clear();
    gmail.clear();
    password.clear();
    confirmPassword.clear();
    mobilNumber.clear();
    selectedGender.value = null;

    firstNameError.value = null;
    lastNameError.value = null;
    emailError.value = null;
    gmailError.value = null;
    passwordError.value = null;
    confirmPasswordError.value = null;
    mobileNumberError.value = null;
    genderError.value = null;
  }
}
