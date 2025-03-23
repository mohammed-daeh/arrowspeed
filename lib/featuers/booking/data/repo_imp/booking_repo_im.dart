import 'package:arrowspeed/featuers/booking/data/datasources/firebase_booking_source.dart';
import 'package:arrowspeed/featuers/booking/domin/repositories/booking_repository.dart';

class BookingRepoIm extends BookingRepository {
  final FirebaseBookingSource _source;

  BookingRepoIm(this._source);
  
  @override
  Future<List<BookingWithTrip>> getUserBookingsWithTrips(String userId) {
      return _source.getUserBookingsWithTrips(userId);

  }

 
}