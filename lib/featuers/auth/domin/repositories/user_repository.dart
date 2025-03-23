import 'package:arrowspeed/featuers/auth/data/models/user_model.dart';

abstract class UserRepository {
  Future<String> createUser(UserModel user);
  Future<bool> checkIfEmailExists(String email); 
  Future<String?> getOtp(String userId);
  Future<bool> updateEmail(String userId, String newEmail);
  Future<UserModel?> login(String loginEmail, String password);
  Future<UserModel?> getUserData(String userId);
  Future<void> updateUser(String userId, UserModel user);
}
