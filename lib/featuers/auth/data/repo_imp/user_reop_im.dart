// ignore_for_file: avoid_print

import 'package:arrowspeed/featuers/auth/data/datasources/firebase_firestore_servise.dart';
import 'package:arrowspeed/featuers/auth/data/models/user_model.dart';
import 'package:arrowspeed/featuers/auth/domin/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepoImpl implements UserRepository {
  final FirebaseFirestoreService _database;

  UserRepoImpl(this._database);
///add user 
  @override
  Future<String> createUser(UserModel user) async {
    String docId = _database.generateId(); 
    await _database.addUser(user.copyWith(id: docId));
    return docId;
  }

  @override
  Future<bool> checkIfEmailExists(String email) async {
    try {
      var query = await FirebaseFirestore.instance
          .collection('users')
          .where('loginEmail', isEqualTo: email)
          .limit(1)
          .get();

      return query.docs.isNotEmpty;
    } catch (e) {
      print("❌ خطأ أثناء البحث عن البريد الإلكتروني: $e");
      return false;
    }
  }


///get
  @override
  Future<String?> getOtp(String userId) async {
    return await _database
        .getOtp(userId); 
  }


  @override
  Future<void> updateUser(String userId, UserModel user) async {
    await _database.updateUserData(userId, user);
  }

///update
  @override
  Future<bool> updateEmail(String userId, String newEmail) async {
    return await _database.updateEmailInFirestore(userId, newEmail);
  }

@override
Future<UserModel?> login(String loginEmail, String password) async {
  try {
    UserModel? user = await _database.getUserByEmailToLogin(loginEmail);

    if (user == null) {
      return null; 
    }

    if (user.passwordHash != password) {
      return null; 
    }

    await _database.updateUserLoginStatus(user.id!, true);
    return user; 
  } catch (e) {
    print("Login error: $e");
    return null;
  }
}

///get user
  @override
  Future<UserModel?> getUserData(String userId) async {
    try {
      return await _database.getUserById(userId);
    } catch (e) {
      print("❌ خطأ أثناء جلب بيانات المستخدم في الريبو: $e");
      return null;
    }
  }

}
