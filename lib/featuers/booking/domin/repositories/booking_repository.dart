import 'package:arrowspeed/featuers/booking/data/datasources/firebase_booking_source.dart';

abstract class BookingRepository {
  Future<List<BookingWithTrip>> getUserBookingsWithTrips(String userId);
}
