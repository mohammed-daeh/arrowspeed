import 'package:arrowspeed/featuers/auth/data/models/user_model.dart';


abstract class AdminUserRepository {
  Future<List<UserModel>> getAllUsers({
    String? emailQuery,
    bool? isActive,
  });

  Future<void> addUser(UserModel user,String emailField);

  Future<void> updateUser(UserModel user);

  Future<void> deleteUser(String userId);

  Future<void> toggleBlockUser(String userId, bool isLogin);
}