// ignore_for_file: avoid_print

import 'dart:math';
import 'package:arrowspeed/core/app_router/app_router.dart';
import 'package:arrowspeed/featuers/auth/data/repo_imp/user_reop_im.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {
  final UserRepoImpl _userRepository;
  OtpController(this._userRepository);
  final emailController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    print(
        "📦 البيانات المستلمة عبر Get.arguments: ${Get.arguments}"); 
    if (Get.arguments is Map<String, dynamic>) {
      final args = Get.arguments as Map<String, dynamic>;

      userId.value = args['userId'] ?? '';
      loginEmail.value = args['loginEmail'] ?? '';

      print("🆔 معرف المستخدم: ${userId.value}");
      print("📩 البريد الإلكتروني: ${loginEmail.value}");
    } else {
      print("❌ فشل في قراءة Get.arguments، البيانات غير متوقعة!");
      Get.snackbar("خطأ", "تعذر تحميل بيانات التحقق");
      Get.offAllNamed(AppRouter.login);
    }
  }

  var loginEmail = ''.obs; 
  var userId = ''.obs; 
  Rxn<String> enteredOTP = Rxn<String>(); 
  RxBool isLoading = false.obs; 
  RxBool isVerifying = false.obs; 

  Future<void> verifyOtp() async {
    print("🚀 بدأ التحقق من OTP: ${enteredOTP.value}");

    if (enteredOTP.value?.isEmpty ?? true) {
      Get.snackbar("خطأ", "يرجى إدخال رمز التحقق");
      return;
    }

    print("📩 البريد الإلكتروني المدخل: ${loginEmail.value}");

    if (loginEmail.value.isEmpty) {
      print("❌ خطأ: البريد الإلكتروني فارغ، لا يمكن جلب OTP!");
      Get.snackbar("خطأ", "حدث خطأ أثناء جلب رمز التحقق، حاول مرة أخرى.");
      return;
    }

    isLoading.value = true;

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId.value) 
          .get();

      if (!userDoc.exists) {
        print("❌ خطأ: لم يتم العثور على بيانات المستخدم");
        Get.snackbar("خطأ", "لم يتم العثور على بيانات المستخدم");
        return;
      }

      String storedOtp = userDoc.get('otp');
      String storedEmail = userDoc.get('loginEmail');

      print("📥 رمز التحقق من Firestore: $storedOtp");
      print("📥 البريد الإلكتروني من Firestore: $storedEmail");

      if (storedOtp.isEmpty || storedEmail.isEmpty) {
        print("❌ خطأ: بيانات OTP أو البريد الإلكتروني غير موجودة");
        Get.snackbar("خطأ", "بيانات OTP أو البريد الإلكتروني غير موجودة");
        return;
      }

      if (loginEmail.value != storedEmail) {
        print("❌ خطأ: البريد الإلكتروني المدخل غير متطابق مع بيانات النظام");
        Get.snackbar(
            "خطأ", "البريد الإلكتروني المدخل غير متطابق مع بيانات النظام");
        return;
      }

      if (enteredOTP.value == storedOtp) {
        print("✅ الرمز مطابق، سيتم تحديث بيانات المستخدم...");

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId.value) 
            .update({
          'isVerified': true,
          'otp': null 
        });

        Get.snackbar("نجاح", "تم التحقق بنجاح 🎉",
            backgroundColor: Colors.green);

        Get.offAllNamed(AppRouter.login);
      } else {
        print("❌ خطأ: رمز التحقق غير صحيح");
        Get.snackbar("خطأ", "رمز التحقق غير صحيح، حاول مرة أخرى",
            backgroundColor: Colors.red);
        return;
      }
    } catch (e) {
      print("❌ خطأ في التحقق: $e");
      Get.snackbar("خطأ", "فشل التحقق: $e", backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOTP() async {
    try {
      isVerifying.value = true; 

      String newOtp = _generateOTP(); 

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId.value)
          .update({'otp': newOtp});

      Get.snackbar("نجاح", "تم إرسال OTP جديد بنجاح",
          backgroundColor: Colors.green);
      await Future.delayed(Duration(seconds: 3));
      _showOTPinNotification(newOtp);
    } catch (e) {
      Get.snackbar("خطأ", "فشل في إرسال OTP: $e", backgroundColor: Colors.red);
    } finally {
      isVerifying.value = false; 
    }
  }

  String _generateOTP() {
    final random = Random();
    return List.generate(6, (index) => random.nextInt(10).toString()).join();
  }

  void _showOTPinNotification(String otp) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 0,
        channelKey: 'basic_channel',
        title: 'رمز التحقق الخاص بك',
        body: 'OTP: $otp',
        notificationLayout: NotificationLayout.BigText,
        payload: {'sound': 'notification_sound'},
      ),
    );
  }


  Future<void> updateEmail(String newEmail) async {
    final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@arrowspeed\.com$');
    if (newEmail.isEmpty || !emailRegex.hasMatch(newEmail)) {
      Get.snackbar("خطأ", "البريد الإلكتروني غير صالح",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (userId.value.isEmpty || userId.value.isEmpty) {
      Get.snackbar("خطأ", "لم يتم العثور على معرف المستخدم",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    try {
      final success = await _userRepository.updateEmail(userId.value, newEmail);

      if (success) {
        loginEmail.value = newEmail;
        Get.back();
      } else {
        Get.snackbar("خطأ", "فشل في تحديث البريد الإلكتروني",
            backgroundColor: Colors.red, colorText: Colors.white);
      }

      Get.back();

      Get.back();
    } catch (e) {
      Get.back();

      Get.snackbar("خطأ", "حدث خطأ غير متوقع: ${e.toString()}",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      Get.back();
    }
  }
}




