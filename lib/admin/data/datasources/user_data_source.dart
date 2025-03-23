import 'package:arrowspeed/admin/data/datasources/firebase_admin_source.dart';
import 'package:arrowspeed/featuers/auth/data/models/user_model.dart';

class UserDataSource extends FirebaseAdminSource<UserModel> {
  UserDataSource() : super('users');

  // @override
  Future<List<UserModel>> getAllUsers({
    String? emailQuery,
    bool? isActive,
  }) async {
    return getAll(
      fieldQuery: 'loginEmail',
      queryValue: emailQuery?.trim(), // إزالة المسافات الزائدة
      filters: isActive != null ? {'isLogin': isActive} : null,
      fromJson: UserModel.fromJson,
    );
  }

  // @override
  Future<void> addUser(UserModel user,emailField) async {
    return add(
      emailField: emailField,
      item: user,
      toJson: (user) => user.toJson(),
    );
  }

  // @override
  Future<void> updateUser(UserModel user) async {
    return update(
      id: user.id!,
      item: user,
      toJson: (user) => user.toJson(),
    );
  }

  // @override
  Future<void> deleteUser(String userId) async {
    return delete(userId);
  }

  // @override
  Future<void> toggleBlockUser(String userId, bool isLogin) async {
    return updateField(
      id: userId,
      field: 'isLogin',
      value: isLogin,
    );
  }
}
