// ignore_for_file: avoid_print

import 'package:arrowspeed/featuers/booking/data/datasources/firebase_booking_source.dart';
import 'package:arrowspeed/featuers/booking/data/repo_imp/booking_repo_im.dart';
import 'package:arrowspeed/featuers/booking/domin/entities/booking.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class BookingController extends GetxController {
  final BookingRepoIm _repo;
  BookingController(this._repo);

  @override
  void onInit() {
    super.onInit();
    fetchBookings(); 
  }

  RxInt currentIndexDay = 0.obs;
  RxInt totalPrice = 0.obs;
  RxList<List<BookingWithTrip>> tripsPerDay =
      List.generate(4, (_) => <BookingWithTrip>[]).obs;
  RxBool isLoading = false.obs;
  final List<String> status = ['pending', 'active', 'completed', 'cancelled'];

  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<void> fetchBookings() async {
    try {
      final userId = await _getUserId();
      if (userId == null) {
        Get.snackbar('Error', 'User ID not found. Please log in again.');
        return;
      }

      isLoading.value = true;

      print('*************************User ID: $userId');
      print('*************************working to fetch bookings');
      List<BookingWithTrip> bookings =
          await _repo.getUserBookingsWithTrips(userId);

      tripsPerDay[0].clear();
      tripsPerDay[1].clear();
      tripsPerDay[2].clear();
      tripsPerDay[3].clear();

      tripsPerDay[0].assignAll(bookings
          .where((b) => b.booking.status == BookingStatus.pending)
          .toList());
      tripsPerDay[1].assignAll(bookings
          .where((b) => b.booking.status == BookingStatus.active)
          .toList());
      tripsPerDay[2].assignAll(bookings
          .where((b) => b.booking.status == BookingStatus.completed)
          .toList());
      tripsPerDay[3].assignAll(bookings
          .where((b) => b.booking.status == BookingStatus.cancelled)
          .toList());

      print('----------------Pending trips: ${tripsPerDay[0]}');
      print('----------------Active trips: ${tripsPerDay[1]}');
      print('----------------Completed trips: ${tripsPerDay[2]}');
      print('----------------Cancelled trips: ${tripsPerDay[3]}');
    } catch (e) {
      print('❌ Error fetching bookings with trips: $e');
      Get.snackbar('Error', 'Failed to fetch bookings. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }


  String calculateTotalPrice(int passenger, int tripPrice) {
    totalPrice.value = passenger * tripPrice;
    return totalPrice.value.toString();
  }

  double calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    double distanceInMeters = Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
    return double.parse((distanceInMeters / 1000).toStringAsFixed(2));
  }

  String calculateTimeDifference(
      TimeOfDay departureTime, TimeOfDay arrivalTime) {
    final now = DateTime.now();
    final DateTime departureDateTime = DateTime(
        now.year, now.month, now.day, departureTime.hour, departureTime.minute);
    final DateTime arrivalDateTime = DateTime(
        now.year, now.month, now.day, arrivalTime.hour, arrivalTime.minute);

    final Duration difference = arrivalDateTime.difference(departureDateTime);

    if (difference.isNegative) {
      return "Invalid time"; 
    }

    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    return "$hours:$minutes";
  }
}
