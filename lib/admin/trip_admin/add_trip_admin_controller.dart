// ignore_for_file: avoid_print

import 'package:arrowspeed/featuers/trip/data/repo_imp/trip_repo_im.dart';
import 'package:arrowspeed/featuers/trip/data/models/trip_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddTripAdminController extends GetxController {
  final TripRepoIm tripRepo;
  final TextEditingController priceController =
      TextEditingController(text: "0");

  AddTripAdminController(this.tripRepo);

  final List<String> companies = ["شركة النور", "شركة المستقبل", "شركة الأمل"];
  final List<String> services = ["واي فاي", "وجبات خفيفة", "مقاعد مريحة"];
  final Map<String, String> companyImages = {
    "شركة النور": "assets/images/a.png", 
    "شركة المستقبل": "assets/images/b.png",
    "شركة الأمل": "assets/images/c.png",
  };
  RxString selectedCompany = "".obs;
  RxString imageUrl = "".obs; 

  RxList<String> selectedServices = <String>[].obs;
  RxString selectedFrom = "ChooseCity".obs;
  RxString selectedTo = "ChooseCity".obs;
  Rx<DateTime?> tripDate = Rx<DateTime?>(null);
  Rx<TimeOfDay?> dateFrom = Rx<TimeOfDay?>(null);
  Rx<TimeOfDay?> dateTo = Rx<TimeOfDay?>(null);
  RxInt discount = 0.obs;
  RxInt star = 0.obs;
  RxInt pessenger = 1.obs;
  RxDouble price = 0.0.obs;
  RxBool isLoading = false.obs;
  RxBool canSubmit = false.obs;

  LatLng? latLngFrom;
  LatLng? latLngTo;
  final Map<String, LatLng> cities = {
    "Aleppo": LatLng(36.2021, 37.1343),
    "Damascus": LatLng(33.5138, 36.2765),
    "Homs": LatLng(34.7331, 36.7169),
    "Ladhiqiyah": LatLng(35.5291, 35.7855),
    "Hama": LatLng(35.1310, 36.7647),
    "Tartus": LatLng(34.8831, 35.9821),
    "Idlib": LatLng(35.8925, 36.6300),
    "Deir ez-Zor": LatLng(35.3293, 40.2268),
    "Raqqa": LatLng(35.9621, 39.0210),
    "Hasakah": LatLng(36.5340, 40.7682),
    "Qamishli": LatLng(37.0302, 41.2265),
    "Suwayda": LatLng(32.7621, 36.5650),
    "Rural Damascus": LatLng(33.5052, 36.4761),
    "Daraa": LatLng(32.6163, 36.0987),
    "As-Suwayda": LatLng(32.7621, 36.5650),
    "Al-Badiyah": LatLng(33.5735, 38.2387),
  };

  RxBool isCompanyError = false.obs;
  RxBool isServiceError = false.obs;
  RxBool isPriceError = false.obs;
  RxBool isDateError = false.obs;
  RxBool isTimeError = false.obs;
  RxBool isCityError = false.obs;

  @override
  void onInit() {
    resetForm();
    super.onInit();
    everAll([
      tripDate,
      dateFrom,
      dateTo,
      selectedCompany,
      selectedServices,
      selectedFrom,
      selectedTo,
      pessenger,
    ], (_) => updateCanSubmit());
  }

  void selectCompany(String company) {
    selectedCompany.value = company;

    imageUrl.value =
        companyImages[company] ?? ""; 
  }


  void toggleService(String service) {
    if (selectedServices.contains(service)) {
      selectedServices.remove(service);
    } else {
      
      selectedServices.add(service);
    }
  }

  void selectCity(bool isFrom, String city) {
    if (isFrom) {
      selectedFrom.value = city;
      latLngFrom = cities[city];
    } else {
      selectedTo.value = city;
      latLngTo = cities[city];
    }
  }

  Future<void> selectTripDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      tripDate.value = picked;
    }
  }

  Future<void> selectTime(BuildContext context, bool isFrom) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      if (isFrom) {
        dateFrom.value = picked;
      } else {
        dateTo.value = picked;
      }
    }
  }

  void validateForm() {
    isCompanyError.value = selectedCompany.value.isEmpty;
    isServiceError.value = selectedServices.isEmpty;
    isServiceError.value = selectedServices.isEmpty;
    isPriceError.value = pessenger.value <= 0 || price.value <= 0;
    isDateError.value = tripDate.value == null;
    isTimeError.value = dateFrom.value == null ||
        dateTo.value == null ||
        dateFrom.value!.hour >= dateTo.value!.hour;
    isCityError.value = selectedFrom.value == "ChooseCity" ||
        selectedTo.value == "ChooseCity" ||
        selectedFrom.value == selectedTo.value;

    updateCanSubmit();
  }

  void updateCanSubmit() {
    double price = double.tryParse(priceController.text) ?? 0;
    bool isValidDate = tripDate.value != null &&
        dateFrom.value != null &&
        dateTo.value != null &&
        dateFrom.value!.hour < dateTo.value!.hour;

    bool isValidCity = selectedFrom.value != "ChooseCity" &&
        selectedTo.value != "ChooseCity" &&
        selectedFrom.value != selectedTo.value;

    bool isValidPassengerAndPrice = pessenger.value > 0 && price > 0;

    canSubmit.value = isValidDate &&
        selectedCompany.value.isNotEmpty &&
        selectedServices.isNotEmpty &&
        isValidCity &&
        isValidPassengerAndPrice;
  }

  Future<void> addition() async {
    validateForm();

    if (!canSubmit.value) {
      print(validateForm.toString());
      Get.snackbar(
        "بيانات ناقصة",
        "يرجى تعبئة جميع البيانات المطلوبة بشكل صحيح",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    TripModel trip = TripModel(
      company: selectedCompany.value,
      serves: selectedServices,
      tripDate: tripDate.value!,
      discount: discount.value,
      from: selectedFrom.value,
      to: selectedTo.value,
      departureTime: dateFrom.value!,
      arrivalTime: dateTo.value!,
      star: star.value,
      totalSeats: pessenger.value,
      price: double.tryParse(priceController.text) ?? 0,
      latLngFrom: latLngFrom!,
      latLngTo: latLngTo!,
      imageUrl: imageUrl.value,
      availableSeats: pessenger.value,
    );

    try {
      isLoading.value = true;
      await tripRepo.addTrip(trip);
      Get.snackbar(
        'نجاح العملية',
        'تم إضافة الرحلة بنجاح',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      resetForm();
    } catch (e) {
      Get.snackbar(
        'حدث خطأ',
        'فشل في إضافة الرحلة: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // إعادة تعيين النموذج
  void resetForm() {
    selectedCompany.value = "";
    selectedServices.clear();
    selectedFrom.value = "ChooseCity";
    selectedTo.value = "ChooseCity";
    tripDate.value = null;
    dateFrom.value = null;
    dateTo.value = null;
    discount.value = 0;
    star.value = 0;
    pessenger.value = 24;
    priceController.clear();
    latLngFrom = null;
    latLngTo = null;
    isCompanyError.value = false;
    isServiceError.value = false;
    isDateError.value = false;
    isTimeError.value = false;
    isCityError.value = false;
    updateCanSubmit();
  }
}
