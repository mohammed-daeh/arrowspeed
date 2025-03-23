
import 'package:arrowspeed/featuers/trip/data/datasources/firebase_trip_source.dart';
import 'package:arrowspeed/featuers/trip/data/models/trip_model.dart';
import 'package:arrowspeed/featuers/trip/domin/repositories/trip_repository.dart';

class TripRepoIm extends TripRepository {
  final FirebaseTripSource _firebaseTripSource;
  TripRepoIm(this._firebaseTripSource);

  @override
  Future<void> addTrip(TripModel trip) async {
    await _firebaseTripSource.addTrip(trip);
  }

  @override
  Stream<List<TripModel>> streamTrips() {
    return _firebaseTripSource.streamTrips();
  }

  @override

  Future<List<TripModel>> searchTrips(
      {String? from, String? to, String? date}) {
    return _firebaseTripSource.searchTrips(from: from, to: to, date: date);
  }
}
