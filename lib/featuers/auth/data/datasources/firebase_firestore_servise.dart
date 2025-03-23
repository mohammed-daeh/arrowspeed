// ignore_for_file: avoid_print, unnecessary_cast

import 'dart:math';

import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:arrowspeed/featuers/auth/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = "users";

  ///add
  String _generateOtp() {
    final random = Random();
    int otp = random.nextInt(900000) + 100000; // إنشاء رقم عشوائي من 6 أرقام
    return otp.toString();
  }

  String generateId() {
    return FirebaseFirestore.instance.collection('users').doc().id;
  }

  Future<bool> addUser(UserModel user) async {
    try {
      print("🚀 Calling addUser...");

      if (user.loginEmail.endsWith("@arrowspeed.com")) {
        var existingUser = await _firestore
            .collection(collectionName)
            .where('loginEmail', isEqualTo: user.loginEmail)
            .get();

        if (existingUser.docs.isNotEmpty) {
          Get.snackbar('Error', 'This email is already in use.',
              snackPosition: SnackPosition.TOP,
              backgroundColor: AppColors.red.withAlpha(200),
              colorText: Colors.white);
          print("❌ هذا البريد الإلكتروني مستخدم بالفعل!");
          return false; // ⬅️ إرجاع false لمنع الانتقال
        }
      }

      String docId = user.id ?? _firestore.collection(collectionName).doc().id;

      var addUser = user.copyWith(
        id: docId,
        otp: _generateOtp(),
      );

      await _firestore
          .collection(collectionName)
          .doc(docId)
          .set(addUser.toJson());

      print("✅ User added successfully with ID: $docId");
      return true; // ⬅️ تم الإنشاء بنجاح
    } catch (e) {
      print("❌ Failed to add user to Firestore: $e");
      return false;
    }
  }

  ///otp
  Future<String?> getOtp(String userId) async {
    try {
      print("🔍 البحث عن OTP للمستخدم: $userId"); 

      var doc = await _firestore.collection(collectionName).doc(userId).get();

      if (!doc.exists || doc.data() == null) {
        print("❌ الوثيقة غير موجودة أو لا تحتوي على بيانات");
        return null;
      }

      print(
          "📄 بيانات الوثيقة: ${doc.data()}"); 

      return doc.data()?['otp'] as String?;
    } catch (e) {
      print("❌ خطأ أثناء جلب OTP: $e");
      return null;
    }
  }

//update
  Future<bool> updateEmailInFirestore(String userId, String newEmail) async {
    try {
      final doc = await _firestore.collection(collectionName).doc(userId).get();
      if (doc.exists) {
        await _firestore.collection(collectionName).doc(userId).update({
          'loginEmail': newEmail,
        });
        return true;
      } else {
        return false; 
      }
    } catch (e) {
      print("❌ خطأ في تحديث البريد الإلكتروني في Firestore: $e");
      return false; 
    }
  }

  Future<void> updateUserData(String userId, UserModel user) async {
    try {
      await _firestore.collection('users').doc(userId).update(user.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateOtp(String userId, String newOtp) async {
    try {
      await _firestore
          .collection(collectionName)
          .doc(userId)
          .update({'otp': newOtp});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateUserLoginStatus(String userId, bool isLogin) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .update({'isLogin': isLogin});
  }

//get
  Future<UserModel?> getUserById(String userId) async {
    try {
      var doc = await _firestore.collection(collectionName).doc(userId).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("❌ خطأ أثناء جلب بيانات المستخدم من Firestore: $e");
    }
    return null;
  }

  Future<UserModel?> getUserByEmailToLogin(String loginEmail) async {
    var querySnapshot = await _firestore
        .collection('users')
        .where('loginEmail', isEqualTo: loginEmail)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) return null;

    return UserModel.fromJson(
        querySnapshot.docs.first.data() as Map<String, dynamic>);
  }
}
