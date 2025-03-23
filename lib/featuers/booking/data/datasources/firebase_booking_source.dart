// ignore_for_file: avoid_print

import 'package:arrowspeed/featuers/booking/data/models/booking_model.dart';
import 'package:arrowspeed/featuers/trip/data/models/trip_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseBookingSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<BookingWithTrip>> getUserBookingsWithTrips(String userId) async {
    try {
      QuerySnapshot bookingSnapshot = await _firestore
          .collection('bookings')
          .where('userId', isEqualTo: userId)
          .get();

      List<Future<BookingWithTrip>> futures = [];

      for (var doc in bookingSnapshot.docs) {
        BookingModel booking =
            BookingModel.fromJson(doc.data() as Map<String, dynamic>);

        Future<BookingWithTrip> future = _firestore
            .collection('trips')
            .doc(booking.tripId)
            .get()
            .then((tripDoc) {
          TripModel? trip = tripDoc.exists
              ? TripModel.fromJson(tripDoc.data() as Map<String, dynamic>)
              : null;
          return BookingWithTrip(booking: booking, trip: trip);
        });

        futures.add(future);
      }
      print(
          '*****Booking documents: ${bookingSnapshot.docs.map((doc) => doc.data()).toList()}');
      return await Future.wait(futures);
    } catch (e) {
      print('❌ Error fetching bookings with trips: $e');
      return [];
    }
  }
}

class BookingWithTrip {
  final BookingModel booking;
  final TripModel? trip;

  BookingWithTrip({required this.booking, this.trip});
}

