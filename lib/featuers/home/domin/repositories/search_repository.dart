import 'package:arrowspeed/featuers/trip/data/models/trip_model.dart';

abstract class SearchRepository {
  Future<List<TripModel>> searchTrips({
    required String? from,
    required String? to,
    required String? date,
  });
}