import 'package:cloud_firestore/cloud_firestore.dart';

class SearchFirebaseSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = "trips";

  Future<List<Map<String, dynamic>>> searchTrips({
  required String? from,
  required String? to,
  required String? date,
}) async {
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
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  } catch (e) {
    print("🔥 خطأ أثناء البحث عن الرحلات: $e");
    return [];
  }
}
}