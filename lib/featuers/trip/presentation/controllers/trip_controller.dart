// ignore_for_file: avoid_print

import 'package:arrowspeed/featuers/trip/data/repo_imp/trip_repo_im.dart';
import 'package:arrowspeed/featuers/trip/data/models/trip_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TripsController extends GetxController {
  TripRepoIm tripRepo;
  TripsController(this.tripRepo);
  var isLoading = false.obs;

  var selectedDay = DateTime.now().obs;
  var trips = <TripModel>[].obs;
  var filteredTrips = <TripModel>[].obs;
  var weekDays = <DateTime>[].obs;
  var currentIndexDay = 0.obs; 
  final PageController pageController = PageController(initialPage: 0);
  final ScrollController scrollController = ScrollController();
  @override
  void onInit() {
    super.onInit();
    generateWeekDays();
    listenToTrips();
  }

  void resetScroll() {
    Future.delayed(Duration(milliseconds: 100), () {
      pageController.jumpToPage(0); 
      scrollController.jumpTo(0); 
    });
  }

  @override
  void onReady() {
    super.onReady();
    resetScroll(); 
  }

  void generateWeekDays() {
    DateTime today = DateTime.now();
    weekDays.assignAll(
      List.generate(7, (index) => today.add(Duration(days: index))),
    );
  }

  void selectDay(DateTime day, int index) {
    selectedDay.value = day;
    currentIndexDay.value = index; // تحديد اليوم الحالي عند الضغط
    filterTrips(); // تصفية الرحلات حسب اليوم المحدد
  
  }

  void filterTrips() {
    print(
        '+++++++++++++++++++All Trips: ${trips.length}'); 

    filteredTrips.value = trips.where((trip) {
      return DateFormat('yyyy-MM-dd').format(trip.tripDate) ==
          DateFormat('yyyy-MM-dd').format(selectedDay.value);
    }).toList();
    print('🎯 الرحلات بعد التصفية: ${filteredTrips.map((e) => e.toJson())}');
  }

  void searchTrips(String from, String to, String date) async {
    isLoading.value = true; 

    var result = await tripRepo.searchTrips(from: from, to: to, date: date);

    filteredTrips.assignAll(result);

    isLoading.value = false; 
  }

  void listenToTrips() {
    isLoading.value = true;
    print('****************************${isLoading.value}');
    tripRepo.streamTrips().listen((fetchedTrips) {
      print(
          '--------------Fetched Trips: ${fetchedTrips.length}'); 
      trips.assignAll(fetchedTrips);
      print('🚀 جميع الرحلات قبل التصفية: ${trips.map((e) => e.toJson())}');

      filterTrips(); 
      isLoading.value = false;
    }, onError: (e) {
      print("🔥 خطأ أثناء تحميل الرحلات: $e");
      isLoading.value = false;
    });
  }
}
