// ignore_for_file: avoid_print

import 'package:arrowspeed/core/app_router/app_router.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:arrowspeed/featuers/booking/data/models/booking_model.dart';
import 'package:arrowspeed/featuers/booking/data/repo_imp/reservation_repo_im.dart';
import 'package:arrowspeed/featuers/booking/domin/entities/booking.dart';
import 'package:arrowspeed/featuers/profile/data/models/passenger_model.dart';
import 'package:arrowspeed/featuers/profile/domin/entities/passenger.dart';
import 'package:arrowspeed/featuers/trip/data/models/trip_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReservationController extends GetxController {
  final ReservationRepoIm _reservationRepo;
  ReservationController(this._reservationRepo);

  var selectedTrip = Rxn<TripModel>();
  var selectedSeats = <int>[].obs;
  var reservedSeats = <int>[].obs;
  var isPassengerListVisible = false.obs; 
  var passengers = <PassengerModel>[].obs; 
  var selectedPassengers = <PassengerModel>[].obs; 
  RxDouble totalPrice = 0.0.obs;
  var pendingBookingId = ''.obs; 

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is TripModel) {
      selectedTrip.value = Get.arguments;
      fetchReservedSeats();
    }
    fetchPassengers(); 

    addDefaultUser();

    ever(selectedPassengers, (_) => updateTotalPrice());
    ever(selectedSeats, (_) => updateTotalPrice());
    createPendingBooking(); 
  }

  void addDefaultUser() async {
    final userId = await _getUserId();
    if (userId != null) {
      final defaultUser = PassengerModel(
        id: userId,
        userId: userId,
        name: Utils.localize('Me'),
        age: "Unknown",
        gender: PassengerGender.male,
      );

      // إضافة الراكب الافتراضي إذا لم يكن موجودًا بالفعل
      if (!selectedPassengers.any((p) => p.id == userId)) {
        selectedPassengers.add(defaultUser);
      }
    }
  }

  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }


  void fetchReservedSeats() {
    if (selectedTrip.value?.id == null) return;
    try {
      _reservationRepo
          .getReservedSeats(selectedTrip.value!.id!)
          .listen((seats) {
        reservedSeats.assignAll(seats.map((seat) => int.parse(seat)).toList());
      });
    } catch (e) {
      print("Error fetching reserved seats: $e");
      Get.snackbar(
        "Error",
        "Failed to load reserved seats. Please try again later.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> fetchPassengers() async {
    try {
      final userId = await _getUserId();
      if (userId != null) {
        final fetchedPassengers =
            await _reservationRepo.getPassengersByUserId(userId).first;
        passengers.assignAll(fetchedPassengers); 
      }
    } catch (e) {
      print("Error fetching passengers: $e");
    }
  }


  void togglePassengerListVisibility() {
    isPassengerListVisible.toggle(); 
  }

  void addPassenger(PassengerModel passenger) {
    if (!selectedPassengers.any((p) => p.id == passenger.id)) {
      selectedPassengers.add(passenger);
    }
  }

  void removePassenger(PassengerModel passenger) {
    selectedPassengers.removeWhere((p) => p.id == passenger.id);
  }

  void updateTotalPrice() {
    double pricePerSeat = selectedTrip.value?.price ?? 0.0;
    int numberOfSeats = selectedSeats.length;

    totalPrice.value = pricePerSeat * numberOfSeats;


  }

  void toggleSeatSelection(int seatNumber) {
    if (reservedSeats.contains(seatNumber)) {
      return; 
    }

    if (selectedSeats.contains(seatNumber)) {
      selectedSeats.remove(seatNumber);
    } else {
     
      if (selectedSeats.length >= selectedPassengers.length) {
        Get.snackbar(
          "Warning",
          "You cannot select more seats than the number of passengers.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      selectedSeats.add(seatNumber);
    }
  }


  void clearSelection() {
    Get.defaultDialog(
      title: "Clear Selection",
      middleText: "Are you sure you want to clear all selections?",
      confirm: ElevatedButton(
        onPressed: () {
          selectedSeats.clear();
          selectedPassengers.clear();
          addDefaultUser();
          updateTotalPrice();
          Get.back();
        },
        child: Text("Yes"),
      ),
      cancel: ElevatedButton(
        onPressed: () => Get.back(),
        child: Text("No"),
      ),
    );
  }

  Future<void> createPendingBooking() async {
    if (selectedTrip.value == null) return;

    final userId = await _getUserId();
    if (userId == null) {
      Get.snackbar("Error", "User not found.");
      return;
    }

    try {
      final existingPendingBooking = await _reservationRepo
          .getPendingBookingByUserAndTrip(userId, selectedTrip.value!.id!);

      if (existingPendingBooking != null) {
        pendingBookingId.value = existingPendingBooking.id;
        Get.snackbar(
          "Info",
          "You have an existing booking in progress. Resuming it...",
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
        return;
      }

      final booking = BookingModel(
        id: '', 
        tripId: selectedTrip.value!.id!,
        userId: userId,
        passengersCount: selectedPassengers.length,
        seatNumbers: selectedSeats.map((seat) => seat.toString()).toList(),
        totalFare: totalPrice.value,
        status: BookingStatus.pending,
        bookingDate: DateTime.now(),
      );

      String bookingId = await _reservationRepo.createPendingBooking(booking);
      pendingBookingId.value = bookingId; 
      Get.snackbar("Success", "New booking created successfully.");
    } catch (e) {
      Get.snackbar("Error", "Failed to create or resume pending booking: $e");
    }
  }

  Future<void> confirmBooking() async {
    if (pendingBookingId.isEmpty) {
      Get.snackbar("خطأ", "لا يوجد حجز معلق.");
      return;
    }

    if (selectedSeats.isEmpty || selectedPassengers.isEmpty) {
      Get.snackbar("خطأ", "يرجى تحديد المقاعد والركاب.");
      return;
    }

    if (selectedSeats.length != selectedPassengers.length) {
      Get.snackbar("تنبيه", "عدد المقاعد يجب أن يساوي عدد الركاب.");
      return;
    }

    try {
      await _reservationRepo.confirmBooking(
        pendingBookingId.value,
        selectedTrip.value!.id!,
        selectedSeats,
      );

      selectedTrip.update((trip) {
        if (trip != null) {
          trip.totalSeats -= selectedSeats.length;
        }
      });

      Get.snackbar("نجاح", "تم تأكيد الحجز بنجاح. انتقل إلى الدفع.");
      Get.toNamed(AppRouter.confirmPayment);
    } catch (e) {
      Get.snackbar("خطأ", "فشل في تأكيد الحجز: $e");
    }
  }


  Future<void> updateTripSeats(String tripId, List<int> seatNumbers) async {
    try {
      await _reservationRepo.updateTripSeats(tripId, seatNumbers);
    } catch (e) {
      Get.snackbar("Error", "Failed to update trip seats: $e");
    }
  }

  Future<void> activateBooking(String bookingId) async {
    try {
      final updatedBooking = BookingModel(
        id: bookingId, 
        tripId: selectedTrip.value!.id!, 
        userId: await _getUserId() ?? '', 
        passengersCount: selectedPassengers.length, 
        seatNumbers: selectedSeats
            .map((seat) => seat.toString())
            .toList(), 
        totalFare: totalPrice.value, 
        status: BookingStatus.active, 
        bookingDate: DateTime.now(), 
      );

      await _reservationRepo.updateBookingDetails(updatedBooking);

      Get.snackbar("Success", "Booking activated successfully.");

      Get.offAllNamed(AppRouter.mainHome);
    } catch (e) {
      Get.snackbar("Error", "Failed to activate booking: $e");
    }
  }

  bool canProceedToPayment() {
    return selectedSeats.isNotEmpty &&
        selectedPassengers.isNotEmpty &&
        selectedSeats.length == selectedPassengers.length;
  }

}
