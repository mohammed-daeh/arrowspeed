// ignore_for_file: avoid_print, unnecessary_cast

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAdminSource<T> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName;

  FirebaseAdminSource(this.collectionName);

  Future<List<T>> getAll({
    String? fieldQuery, // حقل البحث (مثل loginEmail)
    dynamic queryValue, // قيمة البحث
    Map<String, dynamic>? filters, // الفلترة (مثل isActive)
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      Query query = _firestore.collection(collectionName);

      // إضافة البحث إذا كانت القيم صالحة
      if (fieldQuery != null && queryValue != null && queryValue.isNotEmpty) {
        query = query
            .where(fieldQuery, isGreaterThanOrEqualTo: queryValue)
            .where(fieldQuery, isLessThanOrEqualTo: '$queryValue\uf8ff')
            .orderBy(fieldQuery); // ترتيب حسب حقل البحث
      }

      // إضافة الفلترة إذا كانت القيم صالحة
      filters?.forEach((key, value) {
        if (value != null) {
          query = query.where(key, isEqualTo: value);
        }
      });

      // الحصول على النتائج
      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("❌ خطأ في getAll: $e");
      return [];
    }
  }

  Future<bool> checkIfEmailExists(String field, String value) async {
    try {
      final querySnapshot = await _firestore
          .collection(collectionName)
          .where(field, isEqualTo: value)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("❌ خطأ في checkIfEmailExists: $e");
      return false;
    }
  }

  Future<void> add({
    required T item,
    required Map<String, dynamic> Function(T) toJson,
    String? emailField, // اسم الحقل الذي يحتوي على البريد الإلكتروني
  }) async {
    try {
      // التحقق من وجود البريد الإلكتروني إذا كان الحقل محددًا
      if (emailField != null) {
        final emailValue = toJson(item)[emailField];
        if (emailValue != null) {
          final exists = await checkIfEmailExists(emailField, emailValue);
          if (exists) {
            throw Exception(
                "exists"); // رمي استثناء إذا كان البريد الإلكتروني موجودًا
          }
        }
      }

      // إضافة العنصر إذا لم يكن هناك مشاكل
      final doc = _firestore.collection(collectionName).doc();
      await doc.set(toJson(item));
    } catch (e) {
      print("❌ خطأ في add: $e");
      rethrow; // إعادة رمي الخطأ ليتم التعامل معه في الكونترولر
    }
  }
  // Future<void> add({
  //   required T item,
  //   required Map<String, dynamic> Function(T) toJson,
  //   String? emailField, // اسم الحقل الذي يحتوي على البريد الإلكتروني
  // }) async {
  //   try {
  //     // التحقق من وجود البريد الإلكتروني إذا كان الحقل محددًا
  //     if (emailField != null) {
  //       final emailValue = toJson(item)[emailField];
  //       if (emailValue != null) {
  //         final exists = await checkIfEmailExists(emailField, emailValue);
  //         if (exists) {
  //           throw Exception("البريد الإلكتروني '$emailValue' موجود بالفعل.");
  //         }
  //       }
  //     }

  //     // إضافة العنصر إذا لم يكن هناك مشاكل
  //     final doc = _firestore.collection(collectionName).doc();
  //     await doc.set(toJson(item));
  //   } catch (e) {
  //     print("❌ خطأ في add: $e");
  //     rethrow; // إعادة رمي الخطأ ليتم التعامل معه في الكونترولر
  //   }
  // }

  // /// دالة للتحقق من وجود البريد الإلكتروني
  // Future<bool> checkIfEmailExists(String field, String value) async {
  //   try {
  //     final querySnapshot = await _firestore
  //         .collection(collectionName)
  //         .where(field, isEqualTo: value)
  //         .limit(1)
  //         .get();

  //     return querySnapshot.docs.isNotEmpty;
  //   } catch (e) {
  //     print("❌ خطأ في checkIfEmailExists: $e");
  //     return false;
  //   }
  // }
  // Future<void> add({
  //   required T item,
  //   required Map<String, dynamic> Function(T) toJson,
  // }) async {
  //   try {
  //     final doc = _firestore.collection(collectionName).doc();
  //     await doc.set(toJson(item));
  //   } catch (e) {
  //     print("❌ خطأ في add: $e");
  //   }
  // }

  Future<void> update({
    required String id,
    required T item,
    required Map<String, dynamic> Function(T) toJson,
  }) async {
    try {
      await _firestore.collection(collectionName).doc(id).update(toJson(item));
    } catch (e) {
      print("❌ خطأ في update: $e");
    }
  }

  Future<void> delete(String id) async {
    try {
      await _firestore.collection(collectionName).doc(id).delete();
    } catch (e) {
      print("❌ خطأ في delete: $e");
    }
  }

  Future<void> updateField({
    required String id,
    required String field,
    required dynamic value,
  }) async {
    try {
      await _firestore
          .collection(collectionName)
          .doc(id)
          .update({field: value});
    } catch (e) {
      print("❌ خطأ في updateField: $e");
    }
  }
}
// class FirebaseAdminSource {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final String collectionName = "users";

//   // ✅ جلب المستخدمين مع فلترة وبحث
//   Future<List<UserModel>> getAllUsers({
//     String? emailQuery,
//     bool? isActive,
//   }) async {
//     try {
//       Query query = _firestore.collection(collectionName);

//       if (emailQuery != null && emailQuery.isNotEmpty) {
//         query = query
//             .where('loginEmail', isGreaterThanOrEqualTo: emailQuery)
//             .where('loginEmail', isLessThanOrEqualTo: '$emailQuery\uf8ff');
//       }

//       if (isActive != null) {
//         query = query.where('isLogin', isEqualTo: isActive);
//       }

//       final snapshot = await query.get();
//       return snapshot.docs
//           .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
//           .toList();
//     } catch (e) {
//       print("❌ خطأ في getAllUsers: $e");
//       return [];
//     }
//   }

//   // ✅ إضافة مستخدم
//   Future<void> addUser(UserModel user) async {
//     try {
//       final doc = _firestore.collection(collectionName).doc();
//       await doc.set(user.copyWith(id: doc.id).toJson());
//     } catch (e) {
//       print("❌ خطأ في addUser: $e");
//     }
//   }

//   // ✅ تعديل مستخدم
//   Future<void> updateUser(UserModel user) async {
//     try {
//       await _firestore.collection(collectionName).doc(user.id).update(user.toJson());
//     } catch (e) {
//       print("❌ خطأ في updateUser: $e");
//     }
//   }

//   // ✅ حذف مستخدم
//   Future<void> deleteUser(String userId) async {
//     try {
//       await _firestore.collection(collectionName).doc(userId).delete();
//     } catch (e) {
//       print("❌ خطأ في deleteUser: $e");
//     }
//   }

//   // ✅ تغيير حالة المستخدم (بلوك/إلغاء بلوك)
//   Future<void> toggleBlockUser(String userId, bool isLogin) async {
//     try {
//       await _firestore.collection(collectionName).doc(userId).update({'isLogin': isLogin});
//     } catch (e) {
//       print("❌ خطأ في toggleBlockUser: $e");
//     }
//   }
// }

// class FirebaseAdminSource {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final String collectionName = "users";

//   /// جلب المستخدمين مع البحث والفلترة
//   Future<List<UserModel>> getAllUsers({
//     String? emailQuery,
//     bool? isActive,
//   }) async {
//     try {
//       Query query = _firestore.collection(collectionName);

//       if (emailQuery != null && emailQuery.isNotEmpty) {
//         query = query
//           .where('loginEmail', isGreaterThanOrEqualTo: emailQuery)
//           .where('loginEmail', isLessThanOrEqualTo: '$emailQuery\uf8ff');
//       }

//       if (isActive != null) {
//         query = query.where('isLogin', isEqualTo: isActive);
//       }

//       final snapshot = await query.get();
//       return snapshot.docs
//           .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
//           .toList();
//     } catch (e) {
//       print("❌ خطأ أثناء جلب المستخدمين: $e");
//       return [];
//     }
//   }

//   /// إضافة مستخدم
//   Future<void> addUser(UserModel user) async {
//     try {
//       final docRef = _firestore.collection(collectionName).doc();
//       await docRef.set(user.copyWith(id: docRef.id).toJson());
//     } catch (e) {
//       print("❌ خطأ أثناء إضافة المستخدم: $e");
//     }
//   }

//   /// تعديل بيانات مستخدم
//   Future<void> updateUser(UserModel user) async {
//     try {
//       if (user.id == null) throw "ID غير موجود";
//       await _firestore.collection(collectionName).doc(user.id).update(user.toJson());
//     } catch (e) {
//       print("❌ خطأ أثناء تعديل المستخدم: $e");
//     }
//   }

//   /// حذف مستخدم
//   Future<void> deleteUser(String userId) async {
//     try {
//       await _firestore.collection(collectionName).doc(userId).delete();
//     } catch (e) {
//       print("❌ خطأ أثناء حذف المستخدم: $e");
//     }
//   }

//   /// حظر أو إلغاء حظر مستخدم
//   Future<void> toggleBlockUser(String userId, bool isLogin) async {
//     try {
//       await _firestore.collection(collectionName).doc(userId).update({
//         'isLogin': isLogin,
//       });
//     } catch (e) {
//       print("❌ خطأ أثناء تغيير حالة الحظر: $e");
//     }
//   }
// }

// class FirebaseAdminSource {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final String collectionName = "users";

//   /// Fetch all users with optional filters
//   Future<List<UserModel>> getAllUsers({
//     String? emailQuery, // For searching by email
//     bool? isActive, // For filtering active/inactive users
//   }) async {
//     try {
//       Query query = _firestore.collection(collectionName);

//       // Filter by email if a query is provided
//       if (emailQuery != null && emailQuery.isNotEmpty) {
//         query = query.where('loginEmail', isGreaterThanOrEqualTo: emailQuery)
//                      .where('loginEmail', isLessThanOrEqualTo: '$emailQuery\uf8ff');
//       }

//       // Filter by active status if provided
//       if (isActive != null) {
//         query = query.where('isLogin', isEqualTo: isActive);
//       }

//       // Fetch data from Firestore
//       var snapshot = await query.get();

//       // Map data to UserModel
//       var allUsers = snapshot.docs
//           .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
//           .toList();

//       print("✅ عدد المستخدمين المجلوبين: ${allUsers.length}");
//       return allUsers;
//     } catch (e) {
//       print("❌ خطأ أثناء جلب المستخدمين: $e");
//       return [];
//     }
//   }
// }
// class FirebaseAdminSource {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final String collectionName = "users";

//   ///add
// Future<List<UserModel>> getAllUsers() async {
//   try {
//     var snapshot = await _firestore.collection(collectionName).get();

//     var allUsers = snapshot.docs
//         .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
//         .where((user) => user.loginEmail.endsWith('@arrowspeed.com'))
//         .toList();

//     print("✅ عدد المستخدمين الإداريين: ${allUsers.length}");
//     return allUsers;
//   } catch (e) {
//     print("❌ خطأ أثناء جلب المستخدمين الإداريين: $e");
//     return [];
//   }
// }

// }
