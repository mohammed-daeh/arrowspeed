import 'package:arrowspeed/featuers/booking/data/models/booking_model.dart';
import 'package:arrowspeed/featuers/booking/domin/repositories/reservation_repository.dart';
import 'package:arrowspeed/featuers/profile/data/models/passenger_model.dart';
import 'package:arrowspeed/featuers/booking/data/datasources/firebase_reservation_source.dart';

class ReservationRepoIm extends ReservationRepository {
  final FirebaseReservationSource _source;

  ReservationRepoIm(this._source);

  @override
  Stream<List<String>> getReservedSeats(String tripId) {
    return _source.getReservedSeats(tripId);
  }

  @override
  Stream<List<PassengerModel>> getPassengersByUserId(String userId) {
    return _source.getPassengersByUserId(userId);
  }

  @override
  Future<String> createPendingBooking(BookingModel booking) {
    return _source.createPendingBooking(booking);
  }
  @override
  Future<void> confirmBooking(String bookingId, String tripId, List<int> selectedSeats)  {
    return _source.confirmBooking(bookingId,tripId,selectedSeats);
  }

  

  @override
  Future<void> updateTripSeats(String tripId, List<int> seatNumbers) {
    return _source.updateTripSeats(tripId, seatNumbers);
  }

  @override
  Future<BookingModel?> getPendingBookingByUserAndTrip(
      String userId, String tripId) {
    return _source.getPendingBookingByUserAndTrip(userId, tripId);
  }
  
  @override
 Future<void> updateBookingDetails(BookingModel booking) {
     return _source.updateBookingDetails(booking);

  }
}
