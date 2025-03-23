// ignore_for_file: avoid_print

import 'package:arrowspeed/featuers/profile/data/models/passenger_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PassengerFirebaseSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'passengers';

  Future<void> addPassenger(PassengerModel passenger, String userId) async {
    try {
      final passengerId = _firestore
          .collection('users')
          .doc(userId) 
          .collection('passengers') 
          .doc()
          .id; 

      final updatedPassenger = passenger.copyWith(
        id: passengerId,
        userId: userId, 
      );

      await _firestore
          .collection('users') 
          .doc(userId)
          .collection('passengers') 
          .doc(passengerId) 
          .set(updatedPassenger.toJson());

      print('✅ تم إضافة الراكب بنجاح!');
    } catch (e) {
      print('❌ حدث خطأ أثناء إضافة الراكب: $e');
      rethrow; 
    }
  }

  Future<void> updatePassenger(PassengerModel passenger, String userId) async {
  try {
    await _firestore
        .collection('users') 
        .doc(userId) 
        .collection('passengers')
        .doc(passenger.id) 
        .update({
      'name':passenger. name,
      'age':passenger. age,
      'gender':passenger. gender,
    });

    Get.snackbar("تم التحديث", "تم تحديث بيانات الراكب بنجاح");
  } catch (e) {
    Get.snackbar("خطأ", "حدث خطأ أثناء تحديث بيانات الراكب: $e");
  }
}

  Future<void> deletePassenger(String passengerId, String userId) async {
    try {
      print("حذف الراكب - userId: $userId, passengerId: $passengerId");

    
      await _firestore
          .collection('users') 
          .doc(userId) 
          .collection('passengers') 
          .doc(passengerId) 
          .delete();

      print("✅ تم حذف الراكب بنجاح!");
    } catch (e) {
      print("❌ خطأ أثناء حذف الراكب: $e");
      rethrow;
    }
  }

  Future<List<PassengerModel>> getPassengersByUserIdOnce(String userId) async {
    try {
      if (userId.isEmpty) {
        throw Exception("userId غير صالح");
      }

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('passengers')
          .get(); 

      print("تم جلب ${snapshot.docs.length} مستندات للركاب");

      List<PassengerModel> passengers = [];
      for (var doc in snapshot.docs) {
        try {
          passengers.add(PassengerModel.fromJson(doc.data()));
        } catch (e) {
          print("خطأ أثناء تحويل بيانات الراكب: $e");
        }
      }

      return passengers;
    } catch (e) {
      print("خطأ في استعلام Firestore: $e");
      rethrow;
    }
  }

  Stream<List<PassengerModel>> getPassengersByUserId(String userId) {
    if (userId.isEmpty) {
      throw Exception("userId غير صالح");
    }

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('passengers')
        .snapshots()
        .map((snapshot) {
      print("تم جلب ${snapshot.docs.length} مستندات للراكبين");

      List<PassengerModel> passengers = [];

      for (var doc in snapshot.docs) {
        try {
          passengers.add(PassengerModel.fromJson(doc.data()));
        } catch (e) {
          print("خطأ أثناء تحويل بيانات الراكب: $e");
        }
      }

      return passengers;
    }).handleError((error) {
      print("خطأ في استعلام Firestore: $error");
    });
  }

  Future<PassengerModel?> getPassengerById(String id) async {
    try {
      final snapshot =
          await _firestore.collection(collectionName).doc(id).get();

      if (snapshot.exists) {
        return PassengerModel.fromJson(snapshot.data()!);
      }
      return null; 
    } catch (e) {
      print('Error getting passenger by ID: $e');
      rethrow; 
    }
  }
}

