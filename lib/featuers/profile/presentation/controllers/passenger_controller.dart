// ignore_for_file: avoid_print

import 'package:arrowspeed/core/translation/translation.dart';
import 'package:arrowspeed/featuers/profile/data/models/passenger_model.dart';
import 'package:arrowspeed/featuers/profile/data/repo_imp/passenger_rep_imp.dart';
import 'package:arrowspeed/featuers/profile/domin/entities/passenger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PassengerController extends GetxController {
 final PassengerRepositoryImpl _repositoryImpl;
  PassengerController(this._repositoryImpl);

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final nameError = Rxn<String>();
  final ageError = Rxn<String>();
  var selectedGender = Rx<String?>(null); 
  final genderError = Rxn<String>();
  Rx<int?> isEditing =
      Rx<int?>(null); 
  final isLoading = false.obs;
  final isSaving = false.obs;

  var selectedPassengerId = ''.obs;

  void toggleEditPassenger(int index) {
    if (isEditing.value == index) {
      isEditing.value =
          null; 
    } else {
      isEditing.value = index; 
    }
  }

  void updateTextFields(PassengerModel? passenger) {
    if (passenger != null) {
      nameController.text = passenger.name;
      ageController.text = passenger.age.toString();
      selectedGender.value = passenger.gender.toString().split('.').last;
    }
  }

  void clearTextFields() {
    nameController.clear();
    ageController.clear();
    selectedGender.value = null;
    nameError.value = null; 
    ageError.value = null; 
    genderError.value = null; 
  }

  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<void> updatePassenger(Passenger passenger, String id) async {
    final userId = await _getUserId();
    if (userId == null) {
      Get.snackbar("خطأ", "لم يتم العثور على معرف المستخدم");
      return;
    }

    if (_validateAll()) {
      final updatedPassenger = PassengerModel(
        id: id,
        userId: userId,
        name: nameController.text,
        age: ageController.text,
        gender: selectedGender.value == 'male'
            ? PassengerGender.male
            : PassengerGender.female,
      );

     await _repositoryImpl.updatePassenger(updatedPassenger, userId);

      isEditing.value = null; 
    }
  }

  Stream<List<PassengerModel>> getAllPassengers() async* {
    final userId = await _getUserId();
    if (userId != null) {
      yield* _repositoryImpl.getPassengersByUserId(userId);
    } else {
      yield []; 
    }
  }

  Future<void> deletePassenger(String passengerId) async {
    final userId = await _getUserId();
    if (userId == null) {
      Get.snackbar("خطأ", "لم يتم العثور على معرف المستخدم");
      return;
    }

    try {
      await _repositoryImpl.deletePassenger(passengerId, userId);
      Get.snackbar("تم الحذف", "تم حذف الراكب بنجاح");
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء حذف الراكب: $e");
    }
  }

  void updateGender(String gender) {
    selectedGender.value = gender;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return Utils.localize('PleaseEnterName');
    }
    return null;
  }

  String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return Utils.localize('PleaseEnterAge');
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
      String? Function(String?) validator, Rx<String?> error) {
    final errorMessage =
        validator(controller.text); 
    error.value = errorMessage;
  }

  bool _validateAll() {
    final validations = [
      validateName(nameController.text),
      validateAge(ageController.text),
      validateGender(), 
    ];

    [
      nameError,
      ageError,
      genderError, 
    ].asMap().forEach((index, error) {
      error.value = validations[index];     });

    final isValid = validations.every((v) => v == null);
    print("✅ هل جميع الحقول صحيحة؟ $isValid");

    return isValid;
  }

  void resetForm() {
    nameController.clear();
    ageController.clear();
    selectedGender.value = null;

    nameError.value = null;
    ageError.value = null;
    genderError.value = null;
  }

  Future<void> addPassenger() async {
    if (!_validateAll()) {
      print("❌ المدخلات غير صحيحة!");
      return;
    }

    isLoading.value = true; 
    print("🔄 جاري إضافة راكب ...");

    final userId = await _getUserId();
    if (userId == null) {
      Get.snackbar("خطأ", "لم يتم العثور على معرف المستخدم");
      isLoading.value = false; 
      return;
    }

    final passenger = PassengerModel(
      userId: userId,
      name: nameController.text,
      age: ageController.text,
      gender: selectedGender.value == 'male'
          ? PassengerGender.male
          : PassengerGender.female,
    );

    try {
      await _repositoryImpl.addPassenger(passenger, userId);
      print("✅ تم إضافة الراكب بنجاح!");
      clearTextFields();
      
      isLoading.value = false; 
    } catch (e) {
      print("❌ خطأ أثناء الإضافة: $e");
      Get.snackbar("خطأ", e.toString());
      isLoading.value = false; 
    }
  }
}
