// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'package:arrowspeed/featuers/home/data/repo_imp/search_repo_imp.dart';
import 'package:arrowspeed/featuers/home/presentation/screens/search_screen.dart';
import 'package:arrowspeed/featuers/trip/data/models/trip_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

class SearchTripController extends GetxController {
  final SearchRepoImp _repository;
  SearchTripController(this._repository);
  @override
  void onInit() {
    super.onInit();
    updateControllers();
  }

  @override
  void onClose() {
    fromController.dispose();
    toController.dispose();
    dateController.dispose();
    super.onClose();
  }

  var from = ''.obs;
  var to = ''.obs;
  var tripDate = Rx<DateTime?>(null); 
  var filteredTrips = <TripModel>[].obs; 
  var isLoading = false.obs;

  final fromController = TextEditingController();
  final toController = TextEditingController();
  final dateController = TextEditingController();

  final List<String> cities = [
    "Aleppo",
    "Damascus",
    "Homs",
    "Ladhiqiyah",
    "Hama",
    "Tartus",
    "Idlib",
    "Deir ez-Zor",
    "Raqqa",
    "Hasakah",
    "Qamishli",
    "Suwayda",
    "Rural Damascus",
    "Daraa",
    "As-Suwayda",
    "Al-Badiyah",
  ];

  void clearField(String field) {
    switch (field) {
      case 'from':
        from.value = '';
        break;
      case 'to':
        to.value = '';
        break;
      case 'date':
        tripDate.value = null;
        break;
    }
    updateControllers();
  }

  void updateControllers() {
    fromController.text = from.value;
    toController.text = to.value;
    dateController.text = tripDate.value == null
        ? ''
        : DateFormat('yyyy-MM-dd').format(tripDate.value!);
  }

  void resetSearch() {
    from.value = '';
    to.value = '';
    tripDate.value = null;
    updateControllers(); 
  }

  bool canSearch() {
    return from.value.isNotEmpty ||
        to.value.isNotEmpty ||
        tripDate.value != null;
  }

 
  void onTextChanged(String field, String value) {
    switch (field) {
      case 'from':
        from.value = value;
        break;
      case 'to':
        to.value = value;
        break;
    }
  }

 String? getFormattedDateForSearch() {
    if (tripDate.value == null) return null;
    return DateFormat('yyyy-MM-dd').format(tripDate.value!) + 'T00:00:00.000';
  }

  Future<void> searchTrips() async {
    if (!canSearch()) {
      Get.snackbar(
        'خطأ',
        'يجب إدخال أحد الحقول على الأقل!',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final results = await _repository.searchTrips(
        from: from.value.isEmpty ? null : from.value,
        to: to.value.isEmpty ? null : to.value,
        date: getFormattedDateForSearch(),
         );
      filteredTrips.assignAll(results);
      Get.to(() => const SearchResultsScreen());
    } catch (e) {
      print("Error in SearchTripController: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
