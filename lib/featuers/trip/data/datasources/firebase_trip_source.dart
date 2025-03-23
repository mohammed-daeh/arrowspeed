// ignore_for_file: unnecessary_cast, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:arrowspeed/featuers/trip/data/models/trip_model.dart';
import 'package:intl/intl.dart';

class FirebaseTripSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = "trips";

  Future<void> addTrip(TripModel trip) async {
    try {
      String docId = trip.id ?? _firestore.collection(collectionName).doc().id;

      var createdTrip = trip.copyWith(id: docId);

      await _firestore
          .collection(collectionName)
          .doc(docId)
          .set(createdTrip.toJson());

      print("✅ الرحلة تمت إضافتها بنجاح! (ID: $docId)");
    } catch (e) {
      print("🔥 خطأ أثناء إضافة الرحلة: $e");
    }
  }


  Stream<List<TripModel>> streamTrips() {
    try {
      DateTime now = DateTime.now();
      DateTime endOfWeek = now.add(Duration(days: 7));

      String formattedStartDate =
          "${DateFormat('yyyy-MM-dd').format(now)} 00:00:00";
      String formattedEndDate =
          "${DateFormat('yyyy-MM-dd').format(endOfWeek)} 23:59:59";

      return _firestore
          .collection('trips')
          .where('tripDate', isGreaterThanOrEqualTo: formattedStartDate)
          .where('tripDate', isLessThanOrEqualTo: formattedEndDate)
          .snapshots()
          .map((snapshot) {
        print(
            "//////////////////Fetched trips: ${snapshot.docs.map((doc) => doc.data())}");
        print('**********${snapshot.toString()}');
        return snapshot.docs
            .map(
                (doc) => TripModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (e) {
      print("🔥 خطأ أثناء جلب البيانات: $e");
      return Stream.value([]);
    }
  }

  Future<List<TripModel>> searchTrips(
      {String? from, String? to, String? date}) async {
    try {
      Query query = _firestore.collection(collectionName);

      if (from != null && from.isNotEmpty) {
        query = query.where('from', isEqualTo: from);
      }
      if (to != null && to.isNotEmpty) {
        query = query.where('to', isEqualTo: to);
      }
      if (date != null && date.isNotEmpty) {
        query = query.where('tripDate', isEqualTo: date);
      }

      QuerySnapshot snapshot = await query.get();
      return snapshot.docs
          .map((doc) => TripModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("🔥 خطأ أثناء البحث عن الرحلات: $e");
      return [];
    }
  }
}
  