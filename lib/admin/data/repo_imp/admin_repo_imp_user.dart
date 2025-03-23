// ignore_for_file: avoid_print

import 'package:arrowspeed/admin/data/datasources/user_data_source.dart';
import 'package:arrowspeed/admin/domin/repositorys/admin_user_repository.dart';
import 'package:arrowspeed/featuers/auth/data/models/user_model.dart';

// import 'package:arrowspeed/featuers/booking/data/models/ticket_model.dart';
// import 'package:arrowspeed/featuers/trip/data/models/trip_model.dart';
class AdminRepoImpUser implements AdminUserRepository {
  final UserDataSource userDataSource;

  AdminRepoImpUser(this.userDataSource);

  @override
  Future<List<UserModel>> getAllUsers({
    String? emailQuery,
    bool? isActive,
  }) async {
    try {
      // التحقق من صحة القيم المدخلة
      if (emailQuery != null && emailQuery.trim().isEmpty) {
        emailQuery = null; // تجاهل البحث إذا كانت القيمة فارغة
      }

      // الحصول على المستخدمين من مصدر البيانات
      return await userDataSource.getAllUsers(
        emailQuery: emailQuery,
        isActive: isActive,
      );
    } catch (e) {
      // معالجة الأخطاء وإعادة قائمة فارغة في حالة حدوث مشكلة
      print("❌ خطأ في AdminRepoImpUser.getAllUsers: $e");
      return [];
    }
  }

  @override
  Future<void> addUser(UserModel user,String emailField) async {
    try {
      await userDataSource.addUser(user,emailField);
    } catch (e) {
      print("❌ خطأ في AdminRepoImpUser.addUser: $e");
    }
  }

  @override
  Future<void> updateUser(UserModel user) async {
    try {
      await userDataSource.updateUser(user);
    } catch (e) {
      print("❌ خطأ في AdminRepoImpUser.updateUser: $e");
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      await userDataSource.deleteUser(userId);
    } catch (e) {
      print("❌ خطأ في AdminRepoImpUser.deleteUser: $e");
    }
  }

  @override
  Future<void> toggleBlockUser(String userId, bool isLogin) async {
    try {
      await userDataSource.toggleBlockUser(userId, isLogin);
    } catch (e) {
      print("❌ خطأ في AdminRepoImpUser.toggleBlockUser: $e");
    }
  }
}
// class AdminRepoImp extends AdminUserRepository {
//   final UserDataSource source;

//   AdminRepoImp(this.source);

//   @override
//   Future<List<UserModel>> getAllUsers({String? emailQuery, bool? isActive}) async {
//     try {
//       return await source.getAllUsers(emailQuery: emailQuery, isActive: isActive);
//     } catch (e) {
//       throw Exception('Error fetching users: $e');
//     }
//   }

//   @override
//   Future<void> addUser(UserModel user) async {
//     try {
//       await source.addUser(user);
//     } catch (e) {
//       throw Exception('Error adding user: $e');
//     }
//   }

//   @override
//   Future<void> updateUser(UserModel user) async {
//     try {
//       await source.updateUser(user);
//     } catch (e) {
//       throw Exception('Error updating user: $e');
//     }
//   }

//   @override
//   Future<void> deleteUser(String userId) async {
//     try {
//       await source.deleteUser(userId);
//     } catch (e) {
//       throw Exception('Error deleting user: $e');
//     }
//   }

//   @override
//   Future<void> toggleBlockUser(String userId, bool isLogin) async {
//     try {
//       await source.toggleBlockUser(userId, isLogin);
//     } catch (e) {
//       throw Exception('Error toggling block user: $e');
//     }
//   }

//   @override
//   Future<List<TicketModel>> getAllTicket(TicketModel ticket) {
//     throw UnimplementedError();
//   }

//   @override
//   Future<List<TripModel>> getAllTrips(TripModel trips) {
//     throw UnimplementedError();
//   }
// }

// class AdminRepoImp extends AdminRepository {
//   final FirebaseAdminSource source;

//   AdminRepoImp(this.source);

 
//  @override
//   Future<List<UserModel>> getAllUsers({String? emailQuery, bool? isActive}) {
//     return source.getAllUsers(emailQuery: emailQuery, isActive: isActive);
//   }
//  @override

//   Future<void> addUser(UserModel user) => source.addUser(user);
//  @override

//   Future<void> updateUser(UserModel user) => source.updateUser(user);
//  @override

//   Future<void> deleteUser(String userId) => source.deleteUser(userId);
//  @override

//   Future<void> toggleBlockUser(String userId, bool isLogin) =>
//       source.toggleBlockUser(userId, isLogin);

//   @override
//   Future<List<TicketModel>> getAllTicket(TicketModel ticket) {
//     throw UnimplementedError();
//   }

//   @override
//   Future<List<TripModel>> getAllTrips(TripModel trips) {
//     throw UnimplementedError();
//   }
// }
// class AdminRepoImp extends AdminRepository {
//   FirebaseAdminSource source;
//   AdminRepoImp(this.source);
//   @override
//   Future<List<UserModel>> getAllUsers() async{
//      try {
//       // جلب كل المستخدمين من المصدر وتصفيتهم
//       return await source.getAllUsers();
//     } catch (e) {
//       print("❌ خطأ في getAllUsers داخل AdminRepoImp: $e");
//       return [];
//     }
//   }
//   @override
//   Future<List<TicketModel>> getAllTicket(TicketModel ticket) {
//     // TODO: implement getAllTicket
//     throw UnimplementedError();
//   }

//   @override
//   Future<List<TripModel>> getAllTrips(TripModel trips) {
//     // TODO: implement getAllTrips
//     throw UnimplementedError();
//   }


// }
