import 'package:arrowspeed/admin/data/datasources/user_data_source.dart';
import 'package:arrowspeed/admin/data/repo_imp/admin_repo_imp_user.dart';
import 'package:arrowspeed/admin/presentation/controllers/admin_users_controller.dart';
import 'package:get/get.dart';

class AdminUsersBinding extends Bindings {
  @override

  void dependencies() {
   Get.put(UserDataSource());
    Get.put(AdminRepoImpUser(Get.find<UserDataSource>()));
    
    Get.put(AdminUsersController(Get.find<AdminRepoImpUser>()));
  }
}