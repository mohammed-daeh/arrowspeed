// ignore_for_file: avoid_print, unnecessary_brace_in_string_interps

import 'package:arrowspeed/featuers/booking/data/models/booking_model.dart';
import 'package:arrowspeed/featuers/profile/data/models/passenger_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseReservationSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<String>> getReservedSeats(String tripId) {
    return _firestore
        .collection('trips')
        .doc(tripId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return List<String>.from(snapshot.data()?['bookedSeats'] ?? []);
      }
      return [];
    });
  }

  Stream<List<PassengerModel>> getPassengersByUserId(String userId) {
    if (userId.isEmpty) {
      throw Exception("userId غير صالح");
    }

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('passengers')
        .snapshots()
        .map((snapshot) {
      print("تم جلب ${snapshot.docs.length} مستندات للراكبين");

      List<PassengerModel> passengers = [];

      for (var doc in snapshot.docs) {
        try {
          passengers.add(PassengerModel.fromJson(doc.data()));
        } catch (e) {
          print("خطأ أثناء تحويل بيانات الراكب: $e");
        }
      }

      return passengers;
    }).handleError((error) {
      print("خطأ في استعلام Firestore: $error");
    });
  }

  Future<String> createPendingBooking(BookingModel booking) async {
    try {
      String bookingId = DateTime.now().millisecondsSinceEpoch.toString();

      await _firestore.collection('bookings').doc(bookingId).set({
        'id': bookingId,
        'tripId': booking.tripId,
        'userId': booking.userId,
        'passengersCount': booking.passengersCount,
        'seatNumbers': booking.seatNumbers,
        'totalFare': booking.totalFare,
        'status': 'pending', 
        'bookingDate': booking.bookingDate.toIso8601String(),
      });

      return bookingId;
    } catch (e) {
      print("Error creating pending booking: $e");
      throw Exception("Failed to create pending booking.");
    }
  }

  Future<void> confirmBooking(
      String bookingId, String tripId, List<int> selectedSeats) async {
    try {
      final tripRef = _firestore.collection('trips').doc(tripId);
      final tripSnapshot = await tripRef.get();

      if (!tripSnapshot.exists || tripSnapshot.data() == null) {
        throw Exception("الرحلة غير موجودة!");
      }

      final tripData = tripSnapshot.data()!;
      List<String> bookedSeats =
          List<String>.from(tripData['bookedSeats'] ?? []);
      int totalSeats = tripData['totalSeats'] ?? 0;

      if (selectedSeats.any((seat) => bookedSeats.contains(seat.toString()))) {
        throw Exception("بعض المقاعد المحددة محجوزة بالفعل!");
      }

      bookedSeats.addAll(selectedSeats.map((seat) => seat.toString()));

      int newTotalSeats = totalSeats - selectedSeats.length;
      if (newTotalSeats < 0) {
        throw Exception("لا يوجد عدد كافٍ من المقاعد المتاحة!");
      }

      await tripRef.update({
        'bookedSeats': bookedSeats,
        'totalSeats': newTotalSeats,
      });

      await _firestore.collection('bookings').doc(bookingId).update({
        'status': 'confirmed',
      });
    } catch (e) {
      print("خطأ أثناء تأكيد الحجز: $e");
      throw Exception("فشل تأكيد الحجز!");
    }
  }

 

  Future<void> updateTripSeats(String tripId, List<int> seatNumbers) async {
    try {
      DocumentSnapshot tripSnapshot =
          await _firestore.collection('trips').doc(tripId).get();
      if (!tripSnapshot.exists) {
        throw Exception("Trip not found.");
      }

      Map<String, dynamic>? tripData =
          tripSnapshot.data() as Map<String, dynamic>?;
      if (tripData == null) {
        throw Exception("Invalid trip data.");
      }

      List<String> bookedSeats =
          List<String>.from(tripData['bookedSeats'] ?? []);
      int totalSeats = tripData['totalSeats'] ?? 0;

      List<String> updatedBookedSeats = [
        ...bookedSeats,
        ...seatNumbers.map((seat) => seat.toString())
      ];
      int newAvailableSeats = totalSeats - updatedBookedSeats.length;

      await _firestore.collection('trips').doc(tripId).update({
        'bookedSeats': updatedBookedSeats.toSet().toList(), // تجنب التكرار
        'availableSeats': newAvailableSeats,
      });

      print("********Updated trip seats for trip $tripId: "
          "bookedSeats=${updatedBookedSeats}, availableSeats=$newAvailableSeats");
    } catch (e) {
      print("Error updating trip seats: $e");
      throw Exception("Failed to update trip seats.");
    }
  }



  Future<BookingModel?> getPendingBookingByUserAndTrip(
      String userId, String tripId) async {
    try {
      final querySnapshot = await _firestore
          .collection('bookings')
          .where('userId', isEqualTo: userId)
          .where('tripId', isEqualTo: tripId)
          .where('status', isEqualTo: 'pending')
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return BookingModel.fromJson(doc.data());
      }
      return null; 
    } catch (e) {
      print("Error fetching pending booking: $e");
      throw Exception("Failed to fetch pending booking.");
    }
  }

  Future<void> updateBookingDetails(BookingModel booking) async {
    try {
      await _firestore.collection('bookings').doc(booking.id).update({
        'tripId': booking.tripId,
        'userId': booking.userId,
        'passengersCount': booking.passengersCount,
        'seatNumbers': booking.seatNumbers,
        'totalFare': booking.totalFare,
        'status': booking.status
            .toString()
            .split('.')
            .last, // تحويل الحالة إلى String
        'bookingDate':
            booking.bookingDate.toIso8601String(), // تحويل التاريخ إلى String
      });

      print("Updated booking details for booking ${booking.id}: "
          "tripId=${booking.tripId}, userId=${booking.userId}, "
          "passengersCount=${booking.passengersCount}, seatNumbers=${booking.seatNumbers}, "
          "totalFare=${booking.totalFare}, status=${booking.status}");
    } catch (e) {
      print("Error updating booking details: $e");
      throw Exception("Failed to update booking details.");
    }
  }
}
