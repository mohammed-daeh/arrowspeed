import 'package:arrowspeed/featuers/trip/data/models/trip_model.dart';

abstract class TripRepository {
  Future<void> addTrip(TripModel trip);
  Stream<List<TripModel>> streamTrips();
  Future<List<TripModel>> searchTrips({String? from, String? to, String? date});
  
}
