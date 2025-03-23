// ignore_for_file: avoid_print

import 'dart:io';
import 'package:arrowspeed/featuers/auth/data/models/user_model.dart';
import 'package:arrowspeed/featuers/auth/data/repo_imp/user_reop_im.dart';
import 'package:arrowspeed/featuers/auth/domin/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileController extends GetxController {
  final UserRepoImpl _repoImpl;
  EditProfileController(this._repoImpl);

  var firstName = ''.obs;
  var lastName = ''.obs;
  var mobileNumber = ''.obs;
  var selectedGender = 'male'.obs;
  var profilePhoto = ''.obs; 
  var email = ''.obs;
  var isLoading = false.obs;

  UserModel? originalUser; 
  String? _tempProfilePhoto; 

  @override
  void onInit() {
    super.onInit();
    loadUserData(); 
  }

  Future<void> loadUserData() async {
    try {
      isLoading(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString("userId");
      if (userId == null) return;

      UserModel? fetchedUser = await _repoImpl.getUserData(userId);
      if (fetchedUser != null) {
        originalUser = fetchedUser;
        firstName.value = fetchedUser.firstName;
        lastName.value = fetchedUser.lastName;
        mobileNumber.value = fetchedUser.phoneNumber;
        email.value = fetchedUser.loginEmail;
        selectedGender.value =
            fetchedUser.gender == UserGender.male ? 'male' : 'female';
        profilePhoto.value = fetchedUser.profilePhoto;
      }
    } catch (e) {
      print("❌ خطأ أثناء جلب بيانات المستخدم: $e");
    } finally {
      isLoading(false);
    }
  }

  bool get hasChanges {
    if (originalUser == null) return false;
    return firstName.value != originalUser!.firstName ||
        lastName.value != originalUser!.lastName ||
        mobileNumber.value != originalUser!.phoneNumber ||
        selectedGender.value !=
            (originalUser!.gender == UserGender.male ? 'male' : 'female') ||
        (_tempProfilePhoto != null &&
            _tempProfilePhoto != originalUser!.profilePhoto);
  }

  Future<void> saveChanges() async {
    if (!hasChanges) {
      Get.snackbar("معلومات", "لا يوجد تغييرات لحفظها",
          backgroundColor: Colors.blue);
      return;
    }

    isLoading(true);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString("userId");
      if (userId == null) return;

      String? updatedProfilePhoto =
          _tempProfilePhoto ?? originalUser!.profilePhoto;

      UserModel updatedUser = originalUser!.copyWith(
        firstName: firstName.value,
        lastName: lastName.value,
        phoneNumber: mobileNumber.value,
        gender: selectedGender.value == 'male'
            ? UserGender.male
            : UserGender.female,
        profilePhoto: updatedProfilePhoto,
      );

      await _repoImpl.updateUser(userId, updatedUser);

      originalUser = updatedUser;
      profilePhoto.value = updatedProfilePhoto;
      _tempProfilePhoto = null; 

      Get.snackbar("نجاح", "تم تحديث البيانات بنجاح",
          backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar("خطأ", "فشل الحفظ: ${e.toString()}",
          backgroundColor: Colors.red);
    } finally {
      isLoading(false);
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      String? localPath = await saveImageLocally(pickedFile);
      if (localPath != null) {
        _tempProfilePhoto = localPath; 
        Get.snackbar("نجاح", "تم اختيار الصورة بنجاح",
            backgroundColor: Colors.green);
      } else {
        Get.snackbar("خطأ", "فشل حفظ الصورة محليًا",
            backgroundColor: Colors.red);
      }
    }
  }

  Future<String?> saveImageLocally(XFile pickedFile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = File('${directory.path}/$fileName');

      await File(pickedFile.path).copy(savedImage.path);

      return savedImage.path;
    } catch (e) {
      print("❌ خطأ أثناء حفظ الصورة محليًا: $e");
      return null;
    }
  }

  void resetChanges() {
    firstName.value = originalUser!.firstName;
    lastName.value = originalUser!.lastName;
    mobileNumber.value = originalUser!.phoneNumber;
    selectedGender.value =
        originalUser!.gender == UserGender.male ? 'male' : 'female';
    profilePhoto.value = originalUser!.profilePhoto;
    _tempProfilePhoto = null; // إعادة تعيين الصورة المؤقتة
  }
}
