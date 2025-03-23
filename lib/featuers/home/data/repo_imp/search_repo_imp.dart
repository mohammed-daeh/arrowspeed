// ignore_for_file: avoid_print

import 'package:arrowspeed/featuers/home/data/datasources/search_firebase_source.dart';
import 'package:arrowspeed/featuers/home/domin/repositories/search_repository.dart';
import 'package:arrowspeed/featuers/trip/data/models/trip_model.dart';

class SearchRepoImp implements SearchRepository {
  final SearchFirebaseSource _source;

  SearchRepoImp(this._source);

  @override
  Future<List<TripModel>> searchTrips({
    required String? from,
    required String? to,
    required String? date,
  }) async {
    try {
      final rawData = await _source.searchTrips(from: from, to: to, date: date);

      return rawData.map((data) => TripModel.fromJson(data)).toList();
    } catch (e) {
      print("Error in SearchRepoImp: $e");
      return [];
    }
  }
}