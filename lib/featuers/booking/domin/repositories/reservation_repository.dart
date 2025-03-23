import 'package:arrowspeed/featuers/booking/data/models/booking_model.dart';
import 'package:arrowspeed/featuers/profile/data/models/passenger_model.dart';

abstract class ReservationRepository {
  Stream<List<String>> getReservedSeats(String tripId);

  Stream<List<PassengerModel>> getPassengersByUserId(String userId);
  Future<String> createPendingBooking(BookingModel booking);
  Future<void> updateTripSeats(String tripId, List<int> seatNumbers);
  Future<BookingModel?> getPendingBookingByUserAndTrip(
      String userId, String tripId);
  Future<void> updateBookingDetails(BookingModel booking);
  Future<void> confirmBooking(
      String bookingId, String tripId, List<int> selectedSeats);
}
